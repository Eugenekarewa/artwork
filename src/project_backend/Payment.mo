import ArtRegistry "ArtRegistry";
import Marketplace "Marketplace";
import Types "Types";



// Mutable array to store payments
var payments: [Payment] = [];

// Function to create a payment for an order
func createPayment(orderId: Nat, buyer: Text): ?Text {
    // Find the order by ID
    let orderIndex = Array.findIndex<Order>(orders, func (order: Order) : Bool {
        return order.artworkId == orderId and order.buyer == buyer and order.status == "Pending";
    });

    switch (orderIndex) {
        case (?i) {
            let order = orders[i];
            let artworkIndex = Array.findIndex<Artwork>(artworks, func (art: Artwork) : Bool {
                return art.id == order.artworkId;
            });

            switch (artworkIndex) {
                case (?j) {
                    let artwork = artworks[j];
                    
                    // Create a payment
                    let payment: Payment = {
                        orderId = orderId;
                        buyer = buyer;
                        amount = artwork.price; // The amount is the price of the artwork
                        status = "Pending"; // Initially, the payment is pending
                    };

                    // Add the payment to the payments array
                    payments := Array.append(payments, [payment]);

                    // Update the order status to "Payment Pending"
                    orders[i].status := "Payment Pending";

                    return ?("Payment created for artwork ID " # Nat.toText(orderId) # " by buyer " # buyer);
                };
                case null {
                    return null; // Artwork not found
                };
            }
        };
        case null {
            return null; // No pending order found for the given artwork ID by the buyer
        };
    };
};
// Function to process a payment
func processPayment(orderId: Nat, buyer: Text, success: Bool): ?Text {
    // Find the payment associated with the order
    let paymentIndex = Array.findIndex<Payment>(payments, func (payment: Payment) : Bool {
        return payment.orderId == orderId and payment.buyer == buyer and payment.status == "Pending";
    });

    switch (paymentIndex) {
        case (?i) {
            let payment = payments[i];
            let orderIndex = Array.findIndex<Order>(orders, func (order: Order) : Bool {
                return order.artworkId == payment.orderId and order.buyer == payment.buyer;
            });

            switch (orderIndex) {
                case (?j) {
                    // Check if the order is still valid
                    let order = orders[j];
                    if (order.status == "Payment Pending") {
                        if (success) {
                            // Update the payment and order status on successful payment
                            payments[i].status := "Completed";
                            orders[j].status := "Fulfilled"; // Mark the order as fulfilled

                            // You can add logic here to transfer ownership of the artwork if needed

                            return ?("Payment for order ID " # Nat.toText(orderId) # " has been successfully processed.");
                        } else {
                            // Update the payment and order status on failed payment
                            payments[i].status := "Failed";
                            orders[j].status := "Payment Failed"; // Mark the order as failed

                            return ?("Payment for order ID " # Nat.toText(orderId) # " has failed.");
                        }
                    } else {
                        return null; // The order is not in a valid state for payment processing
                    }
                };
                case null {
                    return null; // No order found associated with the payment
                };
            }
        };
        case null {
            return null; // No pending payment found
        };
    }
};
// Function to process a refund for a completed payment
func refundPayment(orderId: Nat, buyer: Text): ?Text {
    // Find the payment associated with the order
    let paymentIndex = Array.findIndex<Payment>(payments, func (payment: Payment) : Bool {
        return payment.orderId == orderId and payment.buyer == buyer and payment.status == "Completed";
    });

    switch (paymentIndex) {
        case (?i) {
            let payment = payments[i];
            let orderIndex = Array.findIndex<Order>(orders, func (order: Order) : Bool {
                return order.artworkId == payment.orderId and order.buyer == payment.buyer;
            });

            switch (orderIndex) {
                case (?j) {
                    // Check if the order is still valid for refund
                    let order = orders[j];
                    if (order.status == "Fulfilled") {
                        // Update the payment and order status on refund
                        payments[i].status := "Refunded";
                        orders[j].status := "Refunded"; // Mark the order as refunded

                        // Logic to handle funds transfer back to the buyer can be added here

                        return ?("Payment for order ID " # Nat.toText(orderId) # " has been successfully refunded.");
                    } else {
                        return null; // The order is not in a valid state for refund
                    }
                };
                case null {
                    return null; // No order found associated with the payment
                };
            }
        };
        case null {
            return null; // No completed payment found for refund
        };
    }
}
