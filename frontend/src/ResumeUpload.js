import React from 'react';

function ResumeUpload() {
  return (
    <form data-testid="upload-form" action="http://localhost:8080/remove" method="post" enctype="multipart/form-data">
      <label htmlFor="data">Upload a resume in PDF format</label>
      <input type="file" name="data" id="data" />
      <input type="submit" />
    </form>
  );
}

export default ResumeUpload;
