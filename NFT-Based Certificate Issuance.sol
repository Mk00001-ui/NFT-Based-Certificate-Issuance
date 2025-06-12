// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract CertificateIssuer is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    // This mapping might become redundant if ownerOf is preferred for current recipient
    mapping(uint256 => address) private _certificateRecipient;

    event CertificateIssued(
        uint256 indexed certificateId,
        address indexed recipient,
        string tokenURI
    );

    constructor() ERC721("NFT Certificate", "NCERT") {}

    function issueCertificate(address _recipient, string memory _tokenURI) public returns (uint256) {
        require(_recipient != address(0), "Recipient address cannot be zero");

        _tokenIdCounter.increment();
        uint256 newCertificateId = _tokenIdCounter.current();

        _safeMint(_recipient, newCertificateId);
        _setTokenURI(newCertificateId, _tokenURI);

        // Store the initial recipient. This is useful if you want to track the original recipient
        // regardless of subsequent transfers.
        _certificateRecipient[newCertificateId] = _recipient;

        emit CertificateIssued(newCertificateId, _recipient, _tokenURI);

        return newCertificateId;
    }

    /**
     * @dev Retrieves the **current ERC721 owner** of a given certificate.
     * @param _certificateId The ID of the certificate.
     * @return The address of the certificate's current owner.
     */
    function getCertificateRecipient(uint256 _certificateId) public view returns (address) {
        // ownerOf will revert if _certificateId does not exist, so no separate existence check needed.
        return ownerOf(_certificateId);
    }

    /**
     * @dev Returns the token URI for a given certificate ID.
     * @param _certificateId The ID of the certificate.
     * @return The URI associated with the certificate's metadata.
     */
    function getCertificateURI(uint256 _certificateId) public view returns (string memory) {
        return tokenURI(_certificateId);
    }
}