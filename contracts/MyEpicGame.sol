// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// NFT contract to inherit from
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


import "hardhat/console.sol";

contract MyEpicGame is ERC721 {
    // Character's attributes held in a struct.
    // (add defense, crit chance, etc if needed)
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 attackDamage;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // Array to help us hold the default data for characters
    CharacterAttributes[] defaultCharacters;

    // mapping from nft's tokenId => that NFTs attributes
    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

    // mapping to store the owner of the NFT
    mapping(address => uint256) public nftHolders;

    // Data passed in to the contract when it's first created initializing the characters.
    // We're going to actually pass these values in from run.js.
    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterAttackDmg
    ) 
        ERC721("Heroes", "HERO")
    {
        // Loop through all the characters, and save the values in the contract
        for (uint256 i = 0; i < characterNames.length; i += 1) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    hp: characterHp[i],
                    maxHp: characterHp[i],
                    attackDamage: characterAttackDmg[i]
            }));

            CharacterAttributes memory c = defaultCharacters[i];

            console.log(
                "Done initializing %s w/ HP %s, img %s",
                c.name,
                c.hp,
                c.imageURI
            );
        }

        // Increment _tokenIds here so that the first NFT has an ID of 1
        _tokenIds.increment();
    }

    // Users Hit this function to get their NFT based on the characterId they send in
    function mintCharacterNFT(uint _characterIndex) external {
        // get current tokenId
        uint256 newItemId = _tokenIds.current();

        // Assigns the tokenId to the caller's wallet address
        _safeMint(msg.sender, newItemId);

        // Map the tokenId => their character attributes
        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp,
            attackDamage: defaultCharacters[_characterIndex].attackDamage
        });

        console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);

        // Keep a way to see who owns what NFT
        nftHolders[msg.sender] = newItemId;

        // Incremement the tokenId for the next person
        _tokenIds.increment();
    }
}
