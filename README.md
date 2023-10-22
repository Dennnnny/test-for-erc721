### hw1 and hw2

use   
`forge test -vvv` to run all test  
or  
`forge test --mc {TestContract} -vvv` to run specific test.  

TestContract are  
`NoUsefulTest`  
`HW_TokenTest`  
`ReceiverContractTest`  
`FreeMintTest`  

note:  
use `forge install` to install the library  
if you could not install  
maybe try remove the lib first then install again.  
`rmdir lib/forge-std lib/openzeppelin-contracts`  
`forge install openzeppelin/openzeppelin-contracts foundry-rs/forge-std --no-commit`  
