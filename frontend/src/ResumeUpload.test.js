import React from 'react';
import { render } from '@testing-library/react';
import ResumeUpload from './ResumeUpload';

test('renders the upload form', () => {
  const { getByTestId } = render(<ResumeUpload />);
  const form = getByTestId('upload-form');

  expect(form).toBeInTheDocument();
});

test('configures the form to point to the backend', () => {
  const { getByTestId } = render(<ResumeUpload />);
  const form = getByTestId('upload-form');

  expect(form.action).toBe('http://localhost:9000/remove');
  expect(form.method).toBe('post');
  expect(form.enctype).toBe('multipart/form-data');
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
