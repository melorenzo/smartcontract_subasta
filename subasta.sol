// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Subasta {
    address public owner;
    string public item;
    uint public finSubasta;
    uint public mejorOferta;
    address public mejorOferente;
    bool public finalizada;

    uint public comision = 2; // 2%

    mapping(address => uint) public ofertas;
    mapping(address => uint[]) public historialOfertas;
    address[] public oferentes;

    event NuevaOferta(address indexed oferente, uint monto);
    event SubastaFinalizada(address ganador, uint montoGanador);
    event Reembolso(address oferente, uint monto);

    modifier soloOwner() {
        require(msg.sender == owner, "No sos el owner de la subasta.");
        _;
    }

    modifier subastaActiva() {
        require(block.timestamp < finSubasta && !finalizada, "La subasta ya finalizo.");
        _;
    }

    constructor(uint _duracionEnSegundos, string memory _item) {
        owner = msg.sender;
        item = _item;
        finSubasta = block.timestamp + _duracionEnSegundos;
    }

    function ofertar() public payable subastaActiva {
        require(msg.value > 0, "La oferta debe ser mayor a 0.");
        uint nuevaOferta = ofertas[msg.sender] + msg.value;

        require(
            nuevaOferta >= mejorOferta + (mejorOferta * 5 / 100),
            "La nueva oferta debe superar en al menos un 5%."
        );

        if (ofertas[msg.sender] == 0) {
            oferentes.push(msg.sender);
        }

        historialOfertas[msg.sender].push(msg.value);
        ofertas[msg.sender] = nuevaOferta;
        mejorOferta = nuevaOferta;
        mejorOferente = msg.sender;

        // Extiende el tiempo si quedan menos de 10 minutos y entra una nueva oferta
        if (finSubasta - block.timestamp <= 10 minutes) {
            finSubasta += 10 minutes;
        }

        emit NuevaOferta(msg.sender, nuevaOferta);
    }

    function obtenerGanador() public view returns (address, uint) {
        require(finalizada, "La subasta aun no ha finalizado.");
        return (mejorOferente, mejorOferta);
    }

    function listarOfertas() public view returns (address[] memory, uint[] memory) {
        uint[] memory montos = new uint[](oferentes.length);
        for (uint i = 0; i < oferentes.length; i++) {
            montos[i] = ofertas[oferentes[i]];
        }
        return (oferentes, montos);
    }

    function finalizarSubasta() public soloOwner {
        require(!finalizada, "Ya se finalizo.");
        require(block.timestamp >= finSubasta, "La subasta sigue activa.");

        _finalizar();
    }

    function finalizarSubastaAnticipadamente() public soloOwner {
        require(!finalizada, "Ya se finalizo.");
        _finalizar();
    }

    function _finalizar() internal {
        finalizada = true;

        for (uint i = 0; i < oferentes.length; i++) {
            address oferente = oferentes[i];
            if (oferente != mejorOferente) {
                uint montoOriginal = ofertas[oferente];
                uint descuento = (montoOriginal * comision) / 100;
                uint reembolso = montoOriginal - descuento;

                ofertas[oferente] = 0;
                payable(oferente).transfer(reembolso);
                emit Reembolso(oferente, reembolso);
            }
        }

        emit SubastaFinalizada(mejorOferente, mejorOferta);
    }

    function retirarExceso() public {
        require(!finalizada, "La subasta ya finalizo.");
        require(historialOfertas[msg.sender].length > 1, "No hay exceso para retirar.");

        uint totalDepositado = ofertas[msg.sender];
        uint ultimaOferta = historialOfertas[msg.sender][historialOfertas[msg.sender].length - 1];
        uint reembolsable = totalDepositado - ultimaOferta;

        require(reembolsable > 0, "Nada para retirar.");
        ofertas[msg.sender] = ultimaOferta;

        payable(msg.sender).transfer(reembolsable);
        emit Reembolso(msg.sender, reembolsable);
    }


    function retirarFondos() public soloOwner {
        require(finalizada, "La subasta aun no finalizo.");
        payable(owner).transfer(address(this).balance);
    }
}
