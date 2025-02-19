<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Front-Office | Upload Passport</title>
  <!-- Font Awesome CDN -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <!-- Google Fonts - Poppins -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --primary-color: #3f51b5;
      --primary-light: #757de8;
      --primary-dark: #002984;
      --secondary-color: #f50057;
      --accent-color: #ff4081;
      --background-color: #f5f7fa;
      --card-color: #ffffff;
      --text-primary: #212121;
      --text-secondary: #757575;
      --text-light: #9e9e9e;
      --border-color: #e0e0e0;
      --border-radius: 10px;
      --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
      --transition: all 0.3s ease;
    }
    
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
    }
    
    body {
      font-family: 'Poppins', sans-serif;
      background-color: var(--background-color);
      color: var(--text-primary);
      line-height: 1.6;
      padding: 2rem;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
    }
    
    .container {
      width: 100%;
      max-width: 600px;
      margin: 0 auto;
    }
    
    .header {
      text-align: center;
      margin-bottom: 3rem;
    }
    
    .title {
      font-size: 2.5rem;
      font-weight: 700;
      color: var(--primary-color);
      position: relative;
      display: inline-block;
      padding-bottom: 1rem;
    }
    
    .title::after {
      content: '';
      position: absolute;
      bottom: 0;
      left: 50%;
      transform: translateX(-50%);
      width: 70%;
      height: 4px;
      background-color: var(--accent-color);
      border-radius: 2px;
    }

    .subtitle {
      font-size: 1.1rem;
      color: var(--text-secondary);
      margin-top: 1rem;
    }
    
    .upload-card {
      background-color: var(--card-color);
      border-radius: var(--border-radius);
      box-shadow: var(--shadow);
      padding: 2rem;
      margin-top: 2rem;
    }
    
    .upload-icon {
      font-size: 4rem;
      color: var(--primary-color);
      text-align: center;
      margin-bottom: 1.5rem;
    }
    
    .upload-area {
      border: 2px dashed var(--border-color);
      border-radius: var(--border-radius);
      padding: 2rem;
      text-align: center;
      margin-bottom: 1.5rem;
      transition: var(--transition);
      cursor: pointer;
    }
    
    .upload-area:hover {
      border-color: var(--primary-color);
      background-color: rgba(63, 81, 181, 0.05);
    }
    
    .upload-text {
      color: var(--text-secondary);
      margin-bottom: 1rem;
    }
    
    .file-input {
      display: none;
    }
    
    .file-label {
      display: inline-block;
      padding: 0.75rem 1.5rem;
      background-color: var(--primary-color);
      color: white;
      border-radius: var(--border-radius);
      cursor: pointer;
      transition: var(--transition);
      font-weight: 500;
    }
    
    .file-label:hover {
      background-color: var(--primary-dark);
    }
    
    .upload-btn {
      width: 100%;
      padding: 1rem;
      background-color: var(--primary-color);
      color: white;
      border: none;
      border-radius: var(--border-radius);
      font-family: 'Poppins', sans-serif;
      font-weight: 500;
      font-size: 1rem;
      cursor: pointer;
      transition: var(--transition);
      display: flex;
      align-items: center;
      justify-content: center;
      margin-top: 1rem;
    }
    
    .upload-btn i {
      margin-right: 0.5rem;
    }
    
    .upload-btn:hover {
      background-color: var(--primary-dark);
    }
    
    .file-name {
      margin-top: 1rem;
      color: var(--text-secondary);
      font-size: 0.9rem;
    }
    
    @media (max-width: 768px) {
      .container {
        padding: 1rem;
      }
      
      .title {
        font-size: 2rem;
      }
      
      .upload-area {
        padding: 1.5rem;
      }
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 class="title">Upload Passport</h1>
      <p class="subtitle">Please upload a clear image of your passport for verification</p>
    </div>
    
    <div class="upload-card">
      <div class="upload-icon">
        <i class="fas fa-passport"></i>
      </div>
      
      <form action="upload_passport" method="post" enctype="multipart/form-data" id="uploadForm">
        <div class="upload-area" onclick="document.getElementById('passportFile').click()">
          <p class="upload-text">Drag and drop your passport image here or click to browse</p>
          <label for="passportFile" class="file-label">
            <i class="fas fa-upload"></i> Choose File
          </label>
          <input type="file" name="passport_image" id="passportFile" class="file-input" required accept="image/*">
          <div class="file-name" id="fileName"></div>
        </div>
        
        <button type="submit" class="upload-btn">
          <i class="fas fa-cloud-upload-alt"></i> Upload Passport
        </button>
      </form>
    </div>
  </div>

  <script>
    document.getElementById('passportFile').addEventListener('change', function(e) {
      const fileName = e.target.files[0]?.name;
      document.getElementById('fileName').textContent = fileName ? `Selected file: ${fileName}` : '';
    });
  </script>
</body>
</html>