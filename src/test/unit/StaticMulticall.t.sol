// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.4;

import {DSTest} from "ds-test/test.sol";
import {Vm} from "forge-std/Vm.sol";
import {ExampleContract} from "$/test/mocks/ExampleContract.sol";
import {StaticMulticall} from "$/StaticMulticall.sol";

contract StaticMulticallUnitTest is DSTest {
    Vm public constant VM = Vm(HEVM_ADDRESS);

    StaticMulticall internal multicall;
    address internal target;

    function setUp() public {
        multicall = new StaticMulticall();
        target = address(new ExampleContract());
    }

    function testViewSuccessCalls() public {
        StaticMulticall.Call[] memory calls = new StaticMulticall.Call[](4);
        calls[0] = StaticMulticall.Call(target, abi.encodeWithSignature("viewNoArguments()"));
        calls[1] = StaticMulticall.Call(target, abi.encodeWithSignature("viewWithArguments(bool)", true));
        calls[2] = StaticMulticall.Call(target, abi.encodeWithSignature("pureNoArguments()"));
        calls[3] = StaticMulticall.Call(target, abi.encodeWithSignature("pureWithArguments(bool)", true));
        (uint256 blockNumber, bytes[] memory returnData) = multicall.aggregate(calls);

        assertEq(blockNumber, 0);
        assertEq(returnData.length, 4);

        assertEq(string(returnData[0]), string(abi.encode(true)));
        assertEq(string(returnData[1]), string(abi.encode(true)));
        assertEq(string(returnData[2]), string(abi.encode(true)));
        assertEq(string(returnData[3]), string(abi.encode(true)));
    }

    function testViewThatThrowsCustomError() public {
        StaticMulticall.Call[] memory calls = new StaticMulticall.Call[](2);
        calls[0] = StaticMulticall.Call(target, abi.encodeWithSignature("viewNoArguments()"));
        calls[1] = StaticMulticall.Call(target, abi.encodeWithSignature("viewThatThrowsCustomError()"));

        VM.expectRevert(abi.encodeWithSignature("CallError(bytes)", abi.encodeWithSignature("ExampleError()")));
        multicall.aggregate(calls);
    }

    function testViewThatThrowsStringError() public {
        StaticMulticall.Call[] memory calls = new StaticMulticall.Call[](2);
        calls[0] = StaticMulticall.Call(target, abi.encodeWithSignature("viewNoArguments()"));
        calls[1] = StaticMulticall.Call(target, abi.encodeWithSignature("viewThatThrowsStringError()"));

        VM.expectRevert(abi.encodeWithSignature("CallError(bytes)", abi.encodeWithSignature("Error(string)", "Lorem ipsum")));
        multicall.aggregate(calls);
    }

    function testStateChangingCalls() public {
        StaticMulticall.Call[] memory calls = new StaticMulticall.Call[](2);
        calls[0] = StaticMulticall.Call(target, abi.encodeWithSignature("viewNoArguments()"));
        calls[1] = StaticMulticall.Call(target, abi.encodeWithSignature("stateChanging()"));

        VM.expectRevert(abi.encodeWithSignature("CallError(bytes)", ""));
        multicall.aggregate(calls);
    }
}
