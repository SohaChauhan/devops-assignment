import React from 'react';
import { Link } from 'react-router-dom';
import { FaShoppingBag, FaUserCheck, FaTruck } from 'react-icons/fa';
import './Home.css';

function Home() {
  return (
    <div className="home">
      <div className="hero">
        <h1 className="hero-title">Welcome to E-Shop</h1>
        <p className="hero-subtitle">Your one-stop destination for quality products</p>
        <Link to="/products" className="btn btn-primary btn-large">
          Browse Products
        </Link>
      </div>

      <div className="features">
        <div className="feature-card">
          <div className="feature-icon">
            <FaShoppingBag />
          </div>
          <h3>Wide Selection</h3>
          <p>Browse through our extensive collection of quality products</p>
        </div>

        <div className="feature-card">
          <div className="feature-icon">
            <FaUserCheck />
          </div>
          <h3>Easy Account</h3>
          <p>Simple registration and secure authentication</p>
        </div>

        <div className="feature-card">
          <div className="feature-icon">
            <FaTruck />
          </div>
          <h3>Fast Delivery</h3>
          <p>Quick order processing and tracking</p>
        </div>
      </div>
    </div>
  );
}

export default Home;

