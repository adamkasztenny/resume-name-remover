import React from 'react';
import ResumeUpload from './ResumeUpload'
import './App.css'

function App() {
  return (
    <div className="container">
      <div className="jumbotron">
      	<h1 className="text-center">Resume Name Remover</h1>
        <hr className="my-4" />
      	<ResumeUpload data-testid="resume-upload" />
      </div>
    </div>
  );
}

export default App;
