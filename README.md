# 🧾 Smart Contract de Subasta - Módulo 2

Este proyecto implementa un contrato inteligente de subasta en la red **Sepolia**, desarrollado como trabajo final del Módulo 2.

---

## ✅ Descripción General

Este contrato permite a múltiples usuarios ofertar por un ítem. Las ofertas deben superar al menos en un 5% la oferta más alta. Al finalizar la subasta:

- Se devuelve el depósito a los perdedores.
- El ganador paga una comisión del 2%.
- El owner puede retirar los fondos del contrato (la oferta ganadora con la comisión descontada).

---

## 🚀 Despliegue

- **Red:** Sepolia
- **Verificado en:** [Etherscan Sepolia](https://sepolia.etherscan.io/)
- **Repositorio:** [GitHub Repo](https://github.com/usuario/subasta-smartcontract)

---

⚙️ Funcionalidades

🏗️ Constructor

constructor(uint _duracionEnSegundos, string memory _item)
Inicializa la subasta con:

_duracionEnSegundos: duración total de la subasta en segundos.

_item: descripción del objeto subastado.

🏷️ Realizar una oferta

function ofertar() public payable
Solo acepta si la nueva oferta supera en al menos un 5% a la actual.

Si quedan menos de 10 minutos, se extiende automáticamente el tiempo.

🥇 Obtener ganador

function obtenerGanador() public view returns (address, uint)
Devuelve el mejor oferente y su oferta.

Solo se puede consultar después de finalizar la subasta.

📜 Listar todas las ofertas

function listarOfertas() public view returns (address[], uint[])
Muestra todas las direcciones que ofertaron y sus montos.

⏹️ Finalizar la subasta

function finalizarSubasta() public onlyOwner
Solo puede ser llamada por el owner.

Marca la subasta como finalizada.

Devuelve el dinero a los perdedores.

Cobra una comisión del 2% al ganador.

💸 Reembolso de exceso (participantes)

function retirarExceso() public
Permite a los usuarios retirar el exceso depositado (cuando han ofertado varias veces).

Solo se puede usar antes de que finalice la subasta.

🔓 Retiro de fondos sobrantes

Permite al **owner** retirar cualquier fondo sobrante que haya quedado en el contrato después de finalizar la subasta. Esto puede incluir:

- Comisiones acumuladas.
- Excedentes no reclamados por los usuarios.

💰 Registro de ofertas
solidity
Copy
Edit
mapping(address => uint) public ofertas;
Guarda el total ofertado por cada dirección.

📢 Eventos
solidity
Copy
Edit
event NuevaOferta(address indexed oferente, uint monto);
event SubastaFinalizada(address ganador, uint montoGanador);
event Reembolso(address oferente, uint monto);
Se emiten durante los momentos clave del ciclo de la subasta.

Facilitan el seguimiento desde interfaces frontend o en herramientas como Etherscan.

🧠 Seguridad y Buenas Prácticas
Uso de modificadores como onlyOwner.

Validaciones estrictas de tiempo y montos.

Implementación del patrón Pull Payment para evitar ataques de reentrada.

Estado controlado para evitar inconsistencias.

Transparencia total en los eventos emitidos.