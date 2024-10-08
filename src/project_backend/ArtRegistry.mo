import Types "Types";
// Define the Artwork type
type Artwork = {
    id: Nat;
    title: Text;
    creator: Text;
    price: Nat;
};

// Array to store artworks (state variable)
var artworks: [Artwork] = [];

// Variable to assign unique IDs
var nextId: Nat = 0;

// Function to register a new artwork
func registerArtwork(title: Text, creator: Text, price: Nat): Artwork {
    let newArtwork: Artwork = {
        id = nextId;
        title = title;
        creator = creator;
        price = price;
    };

    // Add the new artwork to the artworks array
    artworks := Array.append(artworks, [newArtwork]);

    // Increment the ID for the next artwork
    nextId += 1;

    return newArtwork;
};
// Function to update an existing artwork
func updateArtwork(id: Nat, newTitle: Text, newCreator: Text, newPrice: Nat): ?Artwork {
    // Find the index of the artwork with the given ID
    let index = Array.findIndex<Artwork>(artworks, func (art: Artwork) : Bool {
        return art.id == id;
    });

    // If the artwork is found, update it
    switch (index) {
        case (?i) {
            artworks[i] := {
                id = id;
                title = newTitle;
                creator = newCreator;
                price = newPrice;
            };
            return ?artworks[i]; // Return the updated artwork
        };
        case null {
            return null; // Return null if no artwork with the given ID exists
        };
    };
};
// Function to delete an artwork by its ID
func deleteArtwork(id: Nat): ?Artwork {
    // Find the index of the artwork with the given ID
    let index = Array.findIndex<Artwork>(artworks, func (art: Artwork) : Bool {
        return art.id == id;
    });

    // If artwork is found, remove it from the list
    switch (index) {
        case (?i) {
            let removedArtwork = artworks[i]; // Store the artwork to be removed
            artworks := Array.filter<Artwork>(artworks, func (art: Artwork) : Bool {
                return art.id != id;
            });
            return ?removedArtwork; // Return the removed artwork
        };
        case null {
            return null; // Return null if no artwork with the given ID exists
        };
    };
};
// Function to search for artworks by title or creator
func searchArtworks(searchTerm: Text): [Artwork] {
    return Array.filter<Artwork>(artworks, func (art: Artwork) : Bool {
        return String.indexOf(art.title, searchTerm) >= 0 or String.indexOf(art.creator, searchTerm) >= 0;
    });
}
