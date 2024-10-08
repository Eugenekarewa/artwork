import { useState } from 'react';
import { project_backend } from 'declarations/project_backend';

function App() {
  const [artworkTitle, setArtworkTitle] = useState('');
  const [artworkCreator, setArtworkCreator] = useState('');
  const [artworkPrice, setArtworkPrice] = useState('');
  const [message, setMessage] = useState('');

  function handleRegisterArtwork(event) {
    event.preventDefault();
    
    // Register the artwork using the backend service
    project_backend.registerArtwork(artworkTitle, artworkCreator, Number(artworkPrice))
      .then((newArtwork) => {
        setMessage(`Artwork Registered: ${newArtwork.title} by ${newArtwork.creator} with ID: ${newArtwork.id}`);
        // Clear the input fields
        setArtworkTitle('');
        setArtworkCreator('');
        setArtworkPrice('');
      })
      .catch((error) => {
        setMessage(`Error registering artwork: ${error}`);
      });

    return false;
  }

  return (
    <main>
      <img src="/logo2.svg" alt="DFINITY logo" />
      <br />
      <br />
      <form action="#" onSubmit={handleRegisterArtwork}>
        <label htmlFor="title">Artwork Title: &nbsp;</label>
        <input
          id="title"
          value={artworkTitle}
          onChange={(e) => setArtworkTitle(e.target.value)}
          type="text"
          required
        />
        <br />
        <label htmlFor="creator">Creator: &nbsp;</label>
        <input
          id="creator"
          value={artworkCreator}
          onChange={(e) => setArtworkCreator(e.target.value)}
          type="text"
          required
        />
        <br />
        <label htmlFor="price">Price (in tokens): &nbsp;</label>
        <input
          id="price"
          value={artworkPrice}
          onChange={(e) => setArtworkPrice(e.target.value)}
          type="number"
          required
        />
        <br />
        <button type="submit">Register Artwork</button>
      </form>
      <section id="message">{message}</section>
    </main>
  );
}

export default App;
