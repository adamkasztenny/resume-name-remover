import React from 'react';

function ResumeUpload() {
  return (
    <form data-testid="upload-form" action="http://localhost:8080/remove">
      <label htmlFor="filename">Upload a resume in PDF format</label>
      <input type="file" name="filename" id="filename" />
      <input type="submit" />
    </form>
  );
}

export default ResumeUpload;
