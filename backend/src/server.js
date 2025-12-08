const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors()); // Enable Cross-Origin Resource Sharing

// API Routes
app.get('/api/books', (req, res) => {
  const booksPath = path.join(__dirname, 'data', 'books.json');
  fs.readFile(booksPath, 'utf8', (err, data) => {
    if (err) {
      res.status(500).send('Error reading books data');
      return;
    }
    res.json(JSON.parse(data));
  });
});

app.get('/', (req, res) => {
  res.send('Bookstore Backend is running!');
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});