# Contract-Call-With-Yul
A contract, entirely written in yul, can call a solidity contract.

A user can call ```CallTestContractYul.sol``` in order to call ```test.sol```.

```test.sol```
Contains one function, ```add(uint8,uint8) external view returns(uint8)```, that takes 2 uint8s as paramaters and returns the sum.

```CallTestContractYul.sol```
Contains one function that can only be called through txdata. To call the function the fist byte of your calldata must be 0x01.
The first paramater is the contract address of test. Note that it can call any function with the same function seletor as ```add(uint8,uint8)```.
The second paramater is the first uint8 that you wish to add.
The third paramater is the second uint8 that you wish to add.
The contract will return the return value from ```add(uint8,uint8)```.

Example of how to construct the calldata:
0x01 + contract_address + _num1 + _num2
0x01f82a31848ef1488d5e419d1b7b78c43851c181590203
Assuming that the contract address is the address of ```test.sol``` the return value should be 5.
