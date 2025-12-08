import React from 'react';
import BookCard from './BookCard';

const BookList = ({ books, onBuyNow }) => {
  return (
    <div style={{ display: 'flex', flexWrap: 'wrap', justifyContent: 'center', gap: '20px' }}>
      {books.map(book => (
        <BookCard key={book.id} book={book} onBuyNow={onBuyNow} />
      ))}
    </div>
  );
};

export default BookList;