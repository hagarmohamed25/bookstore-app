import React from 'react';
import './BookCard.css'; // Import the CSS file

const BookCard = ({ book, onBuyNow }) => {
  return (
    <div className="book-card">
      <img src={book.imageUrl} alt={book.title} className="book-card-image" />
      <div className="book-card-content">
        <h3 className="book-card-title">{book.title}</h3>
        <p className="book-card-author">by {book.author}</p>
        <p className="book-card-description">{book.description}</p>
        <div className="book-card-footer">
          <span className="book-card-price">${book.price.toFixed(2)}</span>
          <button className="book-card-button" onClick={() => onBuyNow(book.title)}>
            Buy Now
          </button>
        </div>
      </div>
    </div>
  );
};

export default BookCard;