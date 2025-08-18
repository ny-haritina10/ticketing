<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${title != null ? title : 'Flight Admin Dashboard'}</title>
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Google Fonts - Poppins -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
  <style>
    :root {
      --primary-color: #4a6cf7;
      --secondary-color: #142d55;
      --text-color: #333;
      --light-text: #727989;
      --bg-color: #f8f9fa;
      --sidebar-width: 250px;
      --shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      --transition: all 0.3s ease-in-out;
    }
    
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body {
      font-family: 'Poppins', sans-serif;
      background-color: var(--bg-color);
      color: var(--text-color);
      position: relative;
    }
    
    .container {
      display: flex;
      min-height: 100vh;
    }
    
    /* Sidebar Styles */
    .sidebar {
      width: var(--sidebar-width);
      background: linear-gradient(180deg, var(--secondary-color), #0d1f38);
      color: white;
      padding: 1.5rem 0;
      height: 100vh;
      position: fixed;
      transition: var(--transition);
      box-shadow: var(--shadow);
    }
    
    .sidebar-header {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0 1.5rem 1.5rem;
      border-bottom: 1px solid rgba(255, 255, 255, 0.1);
      margin-bottom: 1.5rem;
    }
    
    .logo {
      font-size: 1.5rem;
      font-weight: 700;
      color: white;
      text-decoration: none;
      display: flex;
      align-items: center;
    }
    
    .logo i {
      font-size: 1.8rem;
      margin-right: 0.5rem;
      color: var(--primary-color);
    }
    
    .sidebar-menu {
      list-style: none;
      padding: 0 1.5rem;
    }
    
    .sidebar-item {
      margin-bottom: 0.5rem;
    }
    
    .sidebar-link {
      display: flex;
      align-items: center;
      padding: 0.8rem 1rem;
      color: rgba(255, 255, 255, 0.7);
      text-decoration: none;
      border-radius: 6px;
      transition: var(--transition);
    }
    
    .sidebar-link:hover, .sidebar-link.active {
      background-color: rgba(255, 255, 255, 0.1);
      color: white;
    }
    
    .sidebar-link i {
      margin-right: 0.8rem;
      font-size: 1.2rem;
      width: 1.5rem;
      text-align: center;
      color: var(--primary-color);
    }
    
    .sidebar-footer {
      margin-top: auto;
      padding: 1.5rem;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
      position: absolute;
      bottom: 0;
      width: 100%;
    }
    
    .logout-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0.8rem;
      color: white;
      background-color: rgba(255, 255, 255, 0.1);
      border: none;
      border-radius: 6px;
      cursor: pointer;
      transition: var(--transition);
      width: 100%;
      text-decoration: none;
    }
    
    .logout-btn:hover {
      background-color: rgba(255, 0, 0, 0.2);
    }
    
    .logout-btn i {
      margin-right: 0.5rem;
    }
    
    /* Main Content Styles */
    .main-content {
      flex: 1;
      margin-left: var(--sidebar-width);
      padding: 2rem;
      transition: var(--transition);
      overflow-x: hidden; /* Prevent horizontal overflow */
    }
    
    .header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 2rem;
      padding-bottom: 1rem;
      border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    }
    
    h1 {
      font-size: 1.8rem;
      font-weight: 600;
    }
    
    .content-body {
      background-color: white;
      padding: 2rem;
      border-radius: 8px;
      box-shadow: var(--shadow);
    }
    
    .welcome-message {
      font-size: 1.2rem;
      color: var(--light-text);
      margin-bottom: 2rem;
    }
    
    .dashboard-cards {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 1.5rem;
      margin-bottom: 2rem;
    }
    
    .card {
      background-color: white;
      border-radius: 8px;
      padding: 1.5rem;
      box-shadow: var(--shadow);
      transition: var(--transition);
    }
    
    .card:hover {
      transform: translateY(-5px);
      box-shadow: 0 8px 15px rgba(0, 0, 0, 0.1);
    }
    
    .card i {
      font-size: 2rem;
      color: var(--primary-color);
      margin-bottom: 1rem;
    }
    
    .card-title {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 0.5rem;
    }
    
    .card-subtitle {
      font-size: 0.9rem;
      color: var(--light-text);
    }
    
    /* Updated Table Styles */
    .table-container {
      width: 100%;
      overflow-x: auto; /* Enable horizontal scrolling */
      margin-bottom: 1.5rem;
      max-width: calc(100vw - var(--sidebar-width) - 4rem); /* Constrain to main content width */
    }

    table {
      width: 100%;
      table-layout: auto;
      border-collapse: collapse;
      font-size: 0.85rem;
      min-width: 600px; /* Optional: Set a minimum width for tables */
    }

    
    th, td {
      padding: 0.5rem 0.75rem;
      text-align: left;
      border: 1px solid #dee2e6;
      white-space: nowrap;
    }
    
    th {
      background-color: var(--bg-color);
      font-weight: 600;
      font-size: 0.9rem;
      position: sticky;
      top: 0;
      z-index: 1;
    }
    
    /* For large tables, make last column sticky */
    table.sticky-last td:last-child,
    table.sticky-last th:last-child {
      position: sticky;
      right: 0;
      background-color: #fff;
      box-shadow: -5px 0 5px -2px rgba(0,0,0,0.1);
    }
    
    table.sticky-last th:last-child {
      background-color: var(--bg-color);
    }
    
    /* Handle long content in cells */
    td.data-cell {
      max-width: 200px;
      overflow: hidden;
      text-overflow: ellipsis;
    }
    
    /* Zebra striping for better readability */
    tr:nth-child(even) {
      background-color: rgba(0,0,0,0.02);
    }
    
    tr:hover {
      background-color: rgba(74,108,247,0.05);
    }
    
    form {
      max-width: 800px;
    }
    
    input, select {
      width: 100%;
      padding: 0.75rem;
      margin-bottom: 1rem;
      border: 1px solid #dee2e6;
      border-radius: 4px;
      font-family: 'Poppins', sans-serif;
    }
    
    input[type="submit"] {
      background-color: var(--primary-color);
      color: white;
      border: none;
      cursor: pointer;
      transition: var(--transition);
      font-weight: 500;
    }
    
    input[type="submit"]:hover {
      background-color: #3651c5;
    }
    
    /* Responsive Styles */
    @media (max-width: 992px) {
      .sidebar {
        transform: translateX(-100%);
        z-index: 1000;
      }
      
      .sidebar.active {
        transform: translateX(0);
      }
      
      .main-content {
        margin-left: 0; /* Remove sidebar margin on smaller screens */
      }
      
      .menu-toggle {
        display: block;
        position: fixed;
        top: 1rem;
        left: 1rem;
        z-index: 1001;
        background-color: var(--primary-color);
        color: white;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: var(--shadow);
      }
      
      /* Make tables responsive on mobile */
      .table-container {
        max-width: calc(100vw - 2rem); /* Adjust for smaller screens */
      }
      
      table {
        font-size: 0.75rem;
      }
      
      th, td {
        padding: 0.4rem 0.5rem;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- Sidebar -->
    <aside class="sidebar">
      <div class="sidebar-header">
        <a href="${pageContext.request.contextPath}/admin" class="logo">
          <i class="fas fa-plane-departure"></i>
          <span>Flight Admin</span>
        </a>
      </div>
    
      <ul class="sidebar-menu">
        <!-- Dashboard -->
        <li class="sidebar-item">
          <a href="${pageContext.request.contextPath}/admin" class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-tachometer-alt"></i>
            <span>Dashboard</span>
          </a>
        </li>

        <!-- Flights -->
        <li class="sidebar-item">
          <a href="${pageContext.request.contextPath}/list" class="sidebar-link ${activePage == 'list_flight' ? 'active' : ''}">
            <i class="fas fa-plane"></i>
            <span>Flights</span>
          </a>
        </li>

        <!-- Promotions -->
        <li class="sidebar-item">
          <a href="${pageContext.request.contextPath}/list_promotions" class="sidebar-link ${activePage == 'list_promotions' ? 'active' : ''}">
            <i class="fas fa-percent"></i>
            <span>Promotions</span>
          </a>
        </li>

        <!-- Reservations -->
        <li class="sidebar-item">
          <a href="${pageContext.request.contextPath}/list_reservations_setting" class="sidebar-link ${activePage == 'list_reservations_setting' ? 'active' : ''}">
            <i class="fas fa-calendar-check"></i>
            <span>Reservations</span>
          </a>
        </li>

        <!-- Manage Unbooked Seats -->
        <li class="sidebar-item">
          <a href="${pageContext.request.contextPath}/manage_seat_form" class="sidebar-link ${activePage == 'manage_seats_form' ? 'active' : ''}">
            <i class="fas fa-chair"></i> <!-- seat icon -->
            <span>Manage Unbooked Seats</span>
          </a>
        </li>

        <!-- Unbooked Seats Statistics -->
        <li class="sidebar-item">
          <a href="${pageContext.request.contextPath}/stats_seat" class="sidebar-link ${activePage == 'manage_seats_stats' ? 'active' : ''}">
            <i class="fas fa-chart-bar"></i> <!-- stats icon -->
            <span>Unbooked Seats Statistics</span>
          </a>
        </li>
      </ul>

    
      <!-- Logout -->
      <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
          <i class="fas fa-sign-out-alt"></i>
          <span>Logout</span>
        </a>
      </div>
    </aside>
    
    <!-- Main Content -->
    <main class="main-content">
      <div class="header">
        <h1>${pageTitle != null ? pageTitle : 'Dashboard'}</h1>
        <div class="user-menu">
          <i class="fas fa-user-circle" style="font-size: 2rem; color: var(--primary-color);"></i>
        </div>
      </div>
      
      <div class="content-body">
        <!-- This is where the content from other JSP pages will be included -->
        <jsp:include page="${contentPage}" flush="true" />
      </div>
    </main>
  </div>
  
  <!-- Mobile menu toggle (only shows on smaller screens) -->
  <div class="menu-toggle" id="menu-toggle" style="display: none;">
    <i class="fas fa-bars"></i>
  </div>
  
  <script>
    // Simple toggle for responsive menu
    const menuToggle = document.getElementById('menu-toggle');
    const sidebar = document.querySelector('.sidebar');
    
    if (menuToggle) {
      menuToggle.addEventListener('click', () => {
        sidebar.classList.toggle('active');
      });
    }
    
    // Show/hide menu toggle based on screen width
    function checkWindowSize() {
      if (window.innerWidth <= 992) {
        menuToggle.style.display = 'flex';
      } else {
        menuToggle.style.display = 'none';
        sidebar.classList.remove('active');
      }
    }
    
    window.addEventListener('resize', checkWindowSize);
    window.addEventListener('load', checkWindowSize);
    
    // Initialize tables with many columns
    document.addEventListener('DOMContentLoaded', () => {
      const tables = document.querySelectorAll('table');
      tables.forEach(table => {
        if (table.querySelectorAll('th').length > 6) {
          // Wrap table in container if not already wrapped
          if (!table.parentElement.classList.contains('table-container')) {
            const wrapper = document.createElement('div');
            wrapper.className = 'table-container';
            table.parentNode.insertBefore(wrapper, table);
            wrapper.appendChild(table);
          }
          
          // Add sticky-last class to tables with action columns
          const lastHeader = table.querySelector('th:last-child');
          if (lastHeader && (lastHeader.textContent.trim().toLowerCase().includes('action') || 
                             lastHeader.textContent.trim().toLowerCase().includes('edit') ||
                             lastHeader.textContent.trim().toLowerCase().includes('delete'))) {
            table.classList.add('sticky-last');
          }
        }
      });
    });
  </script>
</body>
</html>