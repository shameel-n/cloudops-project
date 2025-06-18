import React, { useState, useEffect } from 'react';
import {
  AppBar,
  Toolbar,
  Typography,
  Container,
  Card,
  CardContent,
  Grid,
  TextField,
  Button,
  List,
  ListItem,
  ListItemText,
  Box,
  Alert,
  CircularProgress
} from '@mui/material';
import { Add as AddIcon, Storage as StorageIcon } from '@mui/icons-material';
import axios from 'axios';

function App() {
  const [users, setUsers] = useState([]);
  const [newUser, setNewUser] = useState({ name: '', email: '' });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  // API base URL - will be different in production
  const API_URL = process.env.NODE_ENV === 'production' 
    ? '/api' 
    : 'http://localhost:5000/api';

  useEffect(() => {
    fetchUsers();
  }, []);

  const fetchUsers = async () => {
    try {
      setLoading(true);
      const response = await axios.get(`${API_URL}/users`);
      setUsers(response.data);
    } catch (err) {
      setError('Failed to fetch users');
      console.error('Error fetching users:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!newUser.name || !newUser.email) {
      setError('Please fill in all fields');
      return;
    }

    try {
      setLoading(true);
      await axios.post(`${API_URL}/users`, newUser);
      setNewUser({ name: '', email: '' });
      setSuccess('User added successfully!');
      setError('');
      fetchUsers();
    } catch (err) {
      setError('Failed to add user');
      console.error('Error adding user:', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box sx={{ flexGrow: 1, minHeight: '100vh', backgroundColor: '#f5f5f5' }}>
      <AppBar position="static" sx={{ backgroundColor: '#1976d2' }}>
        <Toolbar>
          <StorageIcon sx={{ mr: 2 }} />
          <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
            CloudOps Demo - Three-Tier Architecture
          </Typography>
          <Typography variant="body2">
            Frontend → Backend → Database
          </Typography>
        </Toolbar>
      </AppBar>

      <Container maxWidth="lg" sx={{ mt: 4, pb: 4 }}>
        <Grid container spacing={4}>
          {/* Add User Form */}
          <Grid item xs={12} md={6}>
            <Card>
              <CardContent>
                <Typography variant="h5" gutterBottom color="primary">
                  Add New User
                </Typography>
                {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
                {success && <Alert severity="success" sx={{ mb: 2 }}>{success}</Alert>}
                
                <Box component="form" onSubmit={handleSubmit}>
                  <TextField
                    fullWidth
                    label="Name"
                    value={newUser.name}
                    onChange={(e) => setNewUser({ ...newUser, name: e.target.value })}
                    margin="normal"
                    variant="outlined"
                  />
                  <TextField
                    fullWidth
                    label="Email"
                    type="email"
                    value={newUser.email}
                    onChange={(e) => setNewUser({ ...newUser, email: e.target.value })}
                    margin="normal"
                    variant="outlined"
                  />
                  <Button
                    type="submit"
                    variant="contained"
                    startIcon={loading ? <CircularProgress size={20} /> : <AddIcon />}
                    disabled={loading}
                    fullWidth
                    sx={{ mt: 2 }}
                  >
                    {loading ? 'Adding...' : 'Add User'}
                  </Button>
                </Box>
              </CardContent>
            </Card>
          </Grid>

          {/* Users List */}
          <Grid item xs={12} md={6}>
            <Card>
              <CardContent>
                <Typography variant="h5" gutterBottom color="primary">
                  Users ({users.length})
                </Typography>
                
                {loading && users.length === 0 ? (
                  <Box display="flex" justifyContent="center" p={3}>
                    <CircularProgress />
                  </Box>
                ) : users.length === 0 ? (
                  <Typography variant="body2" color="text.secondary" align="center" sx={{ py: 3 }}>
                    No users found. Add some users to get started!
                  </Typography>
                ) : (
                  <List>
                    {users.map((user) => (
                      <ListItem key={user.id} divider>
                        <ListItemText
                          primary={user.name}
                          secondary={user.email}
                        />
                      </ListItem>
                    ))}
                  </List>
                )}
              </CardContent>
            </Card>
          </Grid>

          {/* Architecture Info */}
          <Grid item xs={12}>
            <Card sx={{ backgroundColor: '#e3f2fd' }}>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  🏗️ Architecture Overview
                </Typography>
                <Typography variant="body2" paragraph>
                  This application demonstrates a three-tier architecture running on AWS EKS:
                </Typography>
                <Box sx={{ ml: 2 }}>
                  <Typography variant="body2" paragraph>
                    <strong>Frontend Tier:</strong> React application with Material-UI (Port 3000)
                  </Typography>
                  <Typography variant="body2" paragraph>
                    <strong>Backend Tier:</strong> Node.js/Express REST API (Port 5000)
                  </Typography>
                  <Typography variant="body2" paragraph>
                    <strong>Database Tier:</strong> PostgreSQL database (Port 5432)
                  </Typography>
                </Box>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      </Container>
    </Box>
  );
}

export default App; 