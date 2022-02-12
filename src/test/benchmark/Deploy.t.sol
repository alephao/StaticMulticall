// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.4;

import {StaticMulticall} from "$/StaticMulticall.sol";

contract DeployBenchmarkTest {
    function testDeploy() public {
        StaticMulticall c = new StaticMulticall();
    }
}
