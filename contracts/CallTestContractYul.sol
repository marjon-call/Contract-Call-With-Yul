
object "CallTestContractYul" {

    code {
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }

    object "runtime" {

        code {
            // get selector
            let callData := calldataload(0)
            let selector := shr(0xf8 , callData) // shifts 2nd to last byte to end
           

            // checks function call
            switch selector
            case 0x01 {

                // calldata stucture:
                // 01 = selector
                // 00..00 next 20 bytes = contract address for static call
                // 00 next byte = first variable for contract call
                // 00 next byte = second variable for contract call

                // gets contract address from calldata
                let shiftedAddress := shr(mul(11,8), callData)
                let contractAddress := and(0xffffffffffffffffffffffffffffffffffffffff, shiftedAddress)

                // gets our first varibale from calldata
                let shiftedVar1 := shr(mul(10, 8), callData)
                let var1 := and(0xff, shiftedVar1)

                
                // gets our second variable from calldata
                let shiftedVar2 := shr(mul(9, 8), callData)
                let var2 := and(0xff, shiftedVar2)
                

                // creates calldata for our static call
                let mptr := mload(0x40) // loads memory slot
                let oldMptr := mptr
                mstore(mptr, 0xbb4e3f4d) // stores function selector
                mstore(add(mptr, 0x20), var1) // stores variable 1 (_num1 for contract call)
                mstore(add(mptr, 0x40), var2) // stores variable 2 (_num2 for contract call)
                mstore(add(mptr, 0x60), add(mptr, 0x60)) // stores call data size

                // makes static contract call
                let s := staticcall(gas(), contractAddress, add(oldMptr, 28), mload(0x60), 0x00, 0x20)

                // checks if call was successful
                if iszero(s) {
                    revert(0,0)
                }
                
                return(0x00, 0x20)
                
            }
            default {
                revert(0,0)
            }
        }

    }

}