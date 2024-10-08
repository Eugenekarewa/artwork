import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Order "mo:base/Order";
import Option "mo:base/Option";
import Principal "mo:base/Principal";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Payment "Payment";
// Define the Artwork type
// Define the Artwork type
type Artwork = {
    id: Nat;
    title: Text;
    creator: Text;
    price: Nat;
    isAvailable: Bool;
};
type Order = {
    artworkId: Nat;
    buyer: Text;
    status: Text; // Could be "Pending", "Fulfilled", etc.
    disputeReason: ?Text; // Optional reason for the dispute
};
type NFT = {
    id: Nat;
    artworkId: Nat; // ID of the artwork this NFT represents
    owner: Text; // Owner of the NFT
    metadata: Text; // Metadata associated with the NFT (e.g., URI of the artwork)
};
module {
    public type Artwork=Principal;
};
type Payment = {
    id: Nat;
    orderId: Nat;
    amount: Nat;
    status: Text;
};