const express = require('express');
const mysql = require('mysql');

const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'sem'
});

// Connect to MySQL database
db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log('Connected to MySQL database');
});

app.post('/api/login', (req, res) => {
  const { username, password } = req.body; 

  db.query('SELECT * FROM exampleusers WHERE username = ? AND password = ?', [username, password], (err, results) => {
    if (err) {
      res.status(500).json({ error: 'Failed to authenticate user' });
    } else {
      if (results.length > 0) {

        console.log("user login successfully");
        res.status(200).json({ message: 'Login successful' });
      } else {
        res.status(401).json({ error: 'Invalid username or password' });
      }
    }
  });
});

app.post('/api/signup', (req, res) => {
  const { username, password, name, dob, bloodGroup, aadharNumber, panNumber, accountNumber, ifscCode, branch, serviceExperience, uanNumber, esaNumber, currentAddress, permanentAddress } = req.body;

  console.log('Received signup request with data:', req.body);

  db.query('SELECT * FROM exampleusers WHERE username = ?', [username], (err, results) => {
    if (err) {
      console.error('Error checking existing username:', err);
      return res.status(500).json({ error: 'Failed to check existing username' });
    }
    if (results.length > 0) {
      return res.status(400).json({ error: 'Username already exists' });
    }

    db.query('INSERT INTO exampleusers (username, password, name, dob, blood_group, aadhar_number, pan_number, account_number, ifsc_code, branch, service_experience, uan_number, esa_number, current_address, permanent_address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [username, password, name, dob, bloodGroup, aadharNumber, panNumber, accountNumber, ifscCode, branch, serviceExperience, uanNumber, esaNumber, currentAddress, permanentAddress], (err, result) => {
      if (err) {
        console.error('Error adding new user:', err);
        return res.status(500).json({ error: 'Failed to add new user' });
      }
      console.log('User signed up successfully:', username);
      res.status(200).json({ message: 'User signed up successfully' });
    });
  });
});

app.post('/api/admin/login', (req, res) => {
  const { username, password } = req.body; 

  db.query('SELECT * FROM exampleadmin WHERE username = ? AND password = ?', [username, password], (err, results) => {
    if (err) {
      res.status(500).json({ error: 'Failed to authenticate user' });
    } else {
      if (results.length > 0) {
        console.log("admin login successfully");
        res.status(200).json({ message: 'Login successful' });
      } else {
        res.status(401).json({ error: 'Invalid username or password' });
      }
    }
  });
});

app.get('/api/users', (req, res) => {
  const { username } = req.query;
  
  console.log(req.body);
  db.query('SELECT * FROM exampleusers', (err, results) => {
    if (err) {
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      console.log("details fetched");
      res.status(200).json(results);
    }
  });
});

app.get('/api/userdetails', (req, res) => {
  console.log(req.query); 
  const { username } = req.query; 
  console.log(username);
  console.log("work well")
  db.query('SELECT * FROM exampleusers WHERE username = ?', [username], (err, results) => {
    if (err) {
      res.status(500).json({ error: 'Internal Server Error' });
    } else {
      console.log("details fetched");
      res.status(200).json(results);
    }
  });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
