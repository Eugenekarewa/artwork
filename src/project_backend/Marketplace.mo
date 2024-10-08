import Types "Types";
import ArtRegistry "ArtRegistry";


// Function to order an artwork
func orderArtwork(artworkId: Nat, buyer: Text): ?Text {
    // Find the artwork by ID
    let index = Array.findIndex<Artwork>(artworks, func (art: Artwork) : Bool {
        return art.id == artworkId and art.isAvailable;
    });

    switch (index) {
        case (?i) {
            let artwork = artworks[i];

            // Check if the artwork is available
            if (artwork.isAvailable) {
                // Mark the artwork as not available
                artworks[i].isAvailable := false;

                // Create an order confirmation message
                return ?("Order created for " # artwork.title # " by " # buyer);
            } else {
                return null; // Artwork is not available for sale
            }
        };
        case null {
            return null; // No artwork found with the given ID
        };
    };
};
// Function to fulfill an order
func fulfillOrder(artworkId: Nat): ?Text {
    // Find the order by artwork ID
    let index = Array.findIndex<Order>(orders, func (order: Order) : Bool {
        return order.artworkId == artworkId and order.status == "Pending";
    });

    switch (index) {
        case (?i) {
            // Update the order status to fulfilled
            orders[i].status := "Fulfilled";

            // Return a confirmation message
            return ?("Order for artwork ID " # Nat.toText(artworkId) # " has been fulfilled.");
        };
        case null {
            return null; // No pending order found for the given artwork ID
        };
    };
};
// Function to cancel an order
func cancelOrder(artworkId: Nat): ?Text {
    // Find the order by artwork ID
    let index = Array.findIndex<Order>(orders, func (order: Order) : Bool {
        return order.artworkId == artworkId and order.status == "Pending";
    });

    switch (index) {
        case (?i) {
            // Update the order status to canceled
            orders[i].status := "Canceled";

            // Mark the artwork as available again
            let artworkIndex = Array.findIndex<Artwork>(artworks, func (art: Artwork) : Bool {
                return art.id == artworkId;
            });
            switch (artworkIndex) {
                case (?j) {
                    artworks[j].isAvailable := true; // Make the artwork available again
                };
                case null {};
            };

            // Return a confirmation message
            return ?("Order for artwork ID " # Nat.toText(artworkId) # " has been canceled.");
        };
        case null {
            return null; // No pending order found for the given artwork ID
        };
    };
};
// Function to raise a dispute for an order
func raiseDispute(artworkId: Nat, buyer: Text, reason: Text): ?Text {
    // Find the order by artwork ID
    let index = Array.findIndex<Order>(orders, func (order: Order) : Bool {
        return order.artworkId == artworkId and order.buyer == buyer and order.status == "Pending";
    });

    switch (index) {
        case (?i) {
            // Update the order status to "Disputed"
            orders[i].status := "Disputed";
            orders[i].disputeReason := ?reason; // Set the dispute reason

            return ?("Dispute raised for artwork ID " # Nat.toText(artworkId) # " by buyer " # buyer);
        };
        case null {
            return null; // No pending order found for the given artwork ID by the buyer
        };
    };
};

// Function to resolve a dispute
func resolveDispute(artworkId: Nat, resolution: Text): ?Text {
    // Find the order by artwork ID
    let index = Array.findIndex<Order>(orders, func (order: Order) : Bool {
        return order.artworkId == artworkId and order.status == "Disputed";
    });

    switch (index) {
        case (?i) {
            // Here you can add your logic for resolving the dispute
            // For example, you could set the order status to "Fulfilled" or "Canceled"
            orders[i].status := "Fulfilled"; // Assume the dispute is resolved in favor of fulfillment
            orders[i].disputeReason := null; // Clear the dispute reason

            return ?("Dispute for artwork ID " # Nat.toText(artworkId) # " has been resolved. Resolution: " # resolution);
        };
        case null {
            return null; // No disputed order found for the given artwork ID
        };
    };
}


