import Payment "Payment";
import Marketplace "Marketplace";
import ArtRegistry "ArtRegistry";
import Types "Types";


// Store NFTs
var nfts: [NFT] = [];

// Function to mint a new NFT
func mintNFT(artworkId: Nat, owner: Text, metadata: Text): ?Text {
    // Check if the artwork exists (you may have a function to validate this)
    let artworkIndex = Array.findIndex<Artwork>(artworks, func (artwork: Artwork) : Bool {
        return artwork.id == artworkId;
    });

    switch (artworkIndex) {
        case (?i) {
            // Generate a unique NFT ID (you might want to implement a better ID generation strategy)
            let nftId = Nat.asNat(Array.size(nfts) + 1); // Simple ID generation by size
            
            // Create a new NFT
            let newNFT = {
                id = nftId;
                artworkId = artworkId;
                owner = owner;
                metadata = metadata;
            };

            // Add the NFT to the storage
            nfts := Array.append<NFT>(nfts, [newNFT]);

            return ?("NFT with ID " # Nat.toText(nftId) # " has been successfully minted for artwork ID " # Nat.toText(artworkId) # ".");
        };
        case null {
            return null; // Artwork not found
        };
    }
};
// Function to transfer an NFT from one owner to another
func transferNFT(nftId: Nat, newOwner: Text, currentOwner: Text): ?Text {
    // Find the index of the NFT being transferred
    let nftIndex = Array.findIndex<NFT>(nfts, func (nft: NFT) : Bool {
        return nft.id == nftId and nft.owner == currentOwner;
    });

    switch (nftIndex) {
        case (?i) {
            // Update the owner of the NFT
            nfts[i].owner := newOwner;

            return ?("NFT with ID " # Nat.toText(nftId) # " has been successfully transferred to " # newOwner # ".");
        };
        case null {
            return null; // NFT not found or current owner mismatch
        };
    }
};
// Function to verify the ownership of an NFT
func verifyNFTOwnership(nftId: Nat, owner: Text): Bool {
    // Find the index of the NFT being verified
    let nftIndex = Array.findIndex<NFT>(nfts, func (nft: NFT) : Bool {
        return nft.id == nftId;
    });

    switch (nftIndex) {
        case (?i) {
            // Return true if the owner matches
            return nfts[i].owner == owner;
        };
        case null {
            return false; // NFT not found
        };
    }
}
