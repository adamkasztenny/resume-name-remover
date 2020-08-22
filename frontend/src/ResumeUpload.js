import React from 'react';

function ResumeUpload() {
  return (
    <form data-testid="upload-form" action="http://localhost:9000/remove" method="post" encType="multipart/form-data">
      <div className="form-group">
        <label htmlFor="data">Upload a resume in PDF format</label>
        <input type="file" name="data" id="data" className="form-control" />
      </div>
      <button type="submit" className="btn btn-primary">Submit</button>
    </form>
  );
}

export default ResumeUpload;
