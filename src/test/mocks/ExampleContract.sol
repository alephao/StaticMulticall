// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.4;

contract ExampleContract {  

    error ExampleError();
    
    bool someState = true;

    function viewNoArguments() external view returns (bool) {
        return someState;
    }

    function viewWithArguments(bool foo) external view returns (bool) {
        return foo == someState;
    }
    
    function viewThatThrowsCustomError() external view returns (bool) {
      if (someState) {
        revert ExampleError();
      }
      return false;
    }

    function viewThatThrowsStringError() external view returns (bool) {
      require(!someState, "Lorem ipsum");
      return false;
    }

    function pureNoArguments() external pure returns (bool) {
        return true;
    }

    function pureWithArguments(bool foo) external pure returns (bool) {
        return foo;
    }

    function stateChanging() external returns (bool) {
        someState = false;
        return true;
    }
}
