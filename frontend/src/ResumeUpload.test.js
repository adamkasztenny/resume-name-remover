import React from 'react';
import { render } from '@testing-library/react';
import ResumeUpload from './ResumeUpload';

test('renders the upload form', () => {
  const { getByTestId } = render(<ResumeUpload />);
  const form = getByTestId('upload-form');
  expect(form).toBeInTheDocument();
  expect(form.action).toBe('http://localhost:8080/remove')
});

test('renders the file upload', () => {
  const { getByLabelText } = render(<ResumeUpload />);
  const fileUpload = getByLabelText('Upload a resume in PDF format');
  expect(fileUpload).toBeInTheDocument();
});

test('renders the submit button', () => {
  const { getByRole } = render(<ResumeUpload />);
  const submitButton = getByRole('button');
  expect(submitButton).toBeInTheDocument();
  expect(submitButton.type).toBe('submit')
});
