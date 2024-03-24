// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import {ISBTIdentityVerifier} from "../interfaces/verifiers/ISBTIdentityVerifier.sol";
import {IZKPQueriesStorage} from "../interfaces/IZKPQueriesStorage.sol";
import {ILightweightState} from "../interfaces/ILightweightState.sol";
import {IQueryValidator} from "../interfaces/IQueryValidator.sol";
import {IVerifiedSBT} from "../interfaces/tokens/IVerifiedSBT.sol";
import {IStorage} from "../interfaces/IStorage.sol";

import {BaseVerifier} from "./BaseVerifier.sol";

contract SBTIdentityVerifier is ISBTIdentityVerifier, BaseVerifier {
    string public constant SBT_IDENTITY_PROOF_QUERY_ID = "SBT_IDENTITY_PROOF";

    IStorage public hashStorage;

    mapping(address => uint256) public override addressToIdentityId;

    mapping(uint256 => SBTIdentityProofInfo) internal _identitiesProofInfo;

    function __SBTIdentityVerifier_init(
        IZKPQueriesStorage zkpQueriesStorage_,
        IStorage sbtToken_
    ) external initializer {
        __BaseVerifier_init(zkpQueriesStorage_);

        hashStorage = sbtToken_;
    }

    function proveIdentity(
        ProveIdentityParams calldata proveIdentityParams_,
        uint256 messageHash
    ) external override {
        _proveIdentity(proveIdentityParams_, messageHash);
    }

    function transitStateAndProveIdentity(
        ProveIdentityParams calldata proveIdentityParams_,
        TransitStateParams calldata transitStateParams_,
        uint256 messageHash
    ) external override {
        _transitState(transitStateParams_);
        _proveIdentity(proveIdentityParams_, messageHash);
    }

    function getIdentityProofInfo(
        uint256 identityId_
    ) external view override returns (SBTIdentityProofInfo memory) {
        return _identitiesProofInfo[identityId_];
    }

    function isIdentityProved(address userAddr_) external view override returns (bool) {
        return _identitiesProofInfo[addressToIdentityId[userAddr_]].isProved;
    }

    function isIdentityProved(uint256 identityId_) public view override returns (bool) {
        return _identitiesProofInfo[identityId_].isProved;
    }

    function _proveIdentity(
        ProveIdentityParams calldata proveIdentityParams_,
        uint256 messageHash
    ) internal {
        _verify(SBT_IDENTITY_PROOF_QUERY_ID, proveIdentityParams_);

        //require(
        //    addressToIdentityId[msg.sender] == 0,
        //    "IdentityVerifier: Msg sender address has already been used to prove the another identity."
        //);

        IQueryValidator queryValidator_ = IQueryValidator(
            zkpQueriesStorage.getQueryValidator(SBT_IDENTITY_PROOF_QUERY_ID)
        );

        // uint256 identityId_ = proveIdentityParams_.inputs[queryValidator_.getUserIdIndex()];

        //require(
        //    !isIdentityProved(identityId_),
        //    "IdentityVerifier: Identity has already been proven."
        //);

        //uint256 newTokenId_ = sbtToken.nextTokenId();
        hashStorage.addMessage(messageHash);

        //addressToIdentityId[msg.sender] = identityId_;
        //_identitiesProofInfo[identityId_] = SBTIdentityProofInfo(msg.sender, newTokenId_, true);

        //emit SBTIdentityProved(identityId_, msg.sender, address(sbtToken), newTokenId_);
    }
}
