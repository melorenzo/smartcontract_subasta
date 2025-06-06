# 🧾 Smart Contract de Subasta - Módulo 2

Este proyecto implementa un contrato inteligente de subasta en la red **Sepolia**, desarrollado como trabajo final del Módulo 2.

---

## ✅ Descripción General

Este contrato permite a múltiples usuarios ofertar por un ítem. Las ofertas deben superar al menos en un 5% la oferta más alta. Al finalizar la subasta:

- Se devuelve el depósito a los perdedores.
- Los oferentes no ganadores reciban su depósito con un descuento del 2%
- El owner puede retirar los fondos del contrato (la oferta ganadora con la comisión descontada).

---

## 🚀 Despliegue

- **Red:** Sepolia
- **Verificado en:** [Etherscan Sepolia](https://sepolia.etherscan.io/)
- **Repositorio:** [GitHub Repo](https://github.com/usuario/subasta-smartcontract)

---

⚙️ Funcionalidades

🏗️ Constructor

```
solidity
constructor(uint _duracionEnSegundos, string memory _item)
```

Inicializa la subasta con:

_duracionEnSegundos: duración total de la subasta en segundos.

_item: descripción del objeto subastado.

🏷️ Realizar una oferta

```
solidity
function ofertar() public payable
```
Solo acepta si la nueva oferta supera en al menos un 5% a la actual.

Si quedan menos de 10 minutos, se extiende automáticamente el tiempo.

🥇 Obtener ganador

```
solidity
function obtenerGanador() public view returns (address, uint)
```

Devuelve el mejor oferente y su oferta.

Solo se puede consultar después de finalizar la subasta.

📜 Listar todas las ofertas

```
solidity
function listarOfertas() public view returns (address[], uint[])
```
Muestra todas las direcciones que ofertaron y sus montos.

⏹️ Finalizar la subasta

```
solidity
function finalizarSubasta() public onlyOwner
```
Solo puede ser llamada por el owner.

Marca la subasta como finalizada.

Devuelve el dinero a los perdedores con un descuento del 2% como comisión.

El ganador no recibe reembolso, ya que se queda con el ítem.

El owner recibe todos los fondos restantes (oferta ganadora + comisiones).

⏹️ Finalización anticipada por el Owner

```
solidity
finalizarSubastaAnticipadamente()
```

El owner tiene la capacidad de finalizar la subasta en cualquier momento mediante la función , incluso si el tiempo original no ha expirado.

💸 Reembolso de exceso (participantes)

```
solidity
function retirarExceso() public
```
Permite a los usuarios retirar el exceso depositado (cuando han ofertado varias veces).

Solo se puede usar antes de que finalice la subasta.

🔓 Retiro de fondos sobrantes

Permite al **owner** retirar cualquier fondo sobrante que haya quedado en el contrato después de finalizar la subasta. Esto puede incluir:

La oferta ganadora.

Las comisiones del 2% aplicadas a los oferentes no ganadores.

Cualquier otro remanente que quede en el contrato.

💰 Registro de ofertas

```
solidity
mapping(address => uint) public ofertas;
```
Guarda el total ofertado por cada dirección.

📢 Eventos

```
solidity
event NuevaOferta(address indexed oferente, uint monto);
event SubastaFinalizada(address ganador, uint montoGanador);
event Reembolso(address oferente, uint monto);
```
Se emiten durante los momentos clave del ciclo de la subasta.

Facilitan el seguimiento desde interfaces frontend o en herramientas como Etherscan.

🧠 Seguridad y Buenas Prácticas
Uso de modificadores como onlyOwner.

Validaciones estrictas de tiempo y montos.

Implementación del patrón Pull Payment para evitar ataques de reentrada.

Estado controlado para evitar inconsistencias.

Transparencia total en los eventos emitidos.
