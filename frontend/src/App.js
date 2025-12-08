import React, { useState, useEffect } from 'react';
import BookList from './components/BookList';
import './App.css';

function App() {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    // This relative path '/api/books' works because Nginx will proxy it
    // to the backend service.
    fetch('/api/books')
      .then(response => {
        if (!response.ok) {
          throw new Error('Something went wrong!');
        }
        return response.json();
      })
      .then(data => {
        setBooks(data);
        setLoading(false);
      })
      .catch(error => {
        setError(error.message);
        setLoading(false);
      });
  }, []);

  const handleBuyNow = (bookTitle) => {
    alert(`You have decided to buy: ${bookTitle}`);
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>DevOps Bookstore</h1>
      </header>
      <main>
        {loading && <p>Loading books...</p>}
        {error && <p style={{ color: 'red' }}>{error}</p>}
        {!loading && !error && <BookList books={books} onBuyNow={handleBuyNow} />}
      </main>
    </div>
  );
}

export default App;