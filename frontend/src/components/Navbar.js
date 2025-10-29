import React from 'react';
import { Link } from 'react-router-dom';
import { FaShoppingCart, FaBox, FaClipboardList, FaSignOutAlt, FaUserCircle } from 'react-icons/fa';
import './Navbar.css';

function Navbar({ user, onLogout, cartCount }) {
  return (
    <nav className="navbar">
      <div className="navbar-container">
        <Link to="/" className="navbar-logo">
          <FaShoppingCart /> E-Shop
        </Link>
        
        <div className="navbar-links">
          <Link to="/products" className="nav-link">
            <FaBox /> Products
          </Link>
          
          {user && user.role === 'admin' && (
            <Link to="/manage-products" className="nav-link">
              Manage Products
            </Link>
          )}
          
          {user && (
            <Link to="/orders" className="nav-link">
              <FaClipboardList /> Orders
            </Link>
          )}
          
          <Link to="/cart" className="nav-link cart-link">
            <FaShoppingCart />
            {cartCount > 0 && <span className="cart-badge">{cartCount}</span>}
          </Link>
          
          {user ? (
            <div className="user-section">
              <span className="user-name">
                <FaUserCircle /> {user.name}
              </span>
              <button onClick={onLogout} className="btn-logout">
                <FaSignOutAlt /> Logout
              </button>
            </div>
          ) : (
            <div className="auth-links">
              <Link to="/login" className="btn btn-primary">Login</Link>
              <Link to="/register" className="btn btn-secondary">Register</Link>
            </div>
          )}
        </div>
      </div>
    </nav>
  );
}

export default Navbar;

