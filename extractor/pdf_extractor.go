package extractor

import (
	"fmt"
	"io"

	"github.com/unidoc/unipdf/v3/extractor"
	pdf "github.com/unidoc/unipdf/v3/model"
)

func PDFExtractor(data io.ReadSeeker) (string, error) {
	pdfReader, err := pdf.NewPdfReaderLazy(data)
	if err != nil {
		return "", fmt.Errorf("cannot create reader: %v", err)
	}

	_, err = getCandidateName(pdfReader)
	if err != nil {
		return "", fmt.Errorf("cannot get candidate name: %v", err)
	}
	return "", nil
}

func getCandidateName(pdfReader *pdf.PdfReader) (string, error) {
	firstPage, err := pdfReader.GetPage(1)
	if err != nil {
		return "", fmt.Errorf("cannot get first page: %v", err)
	}

	extractor, err := extractor.New(firstPage)
	if err != nil {
		return "", fmt.Errorf("cannot create extractor for first page: %v", err)
	}

	pageText, _, _, err := extractor.ExtractPageText()
	if err != nil {
		return "", fmt.Errorf("cannot extract text for first page: %v", err)

	}

	fmt.Println(getLargestText(pageText))
	return "", nil
}

func getLargestText(pageText *extractor.PageText) string {
	var largestText string
	var largestFont float64

	for _, textMark := range pageText.Marks().Elements() {
		if textMark.FontSize >= largestFont {
			largestFont = textMark.FontSize
			largestText = largestText + textMark.Text
		}
	}
	return largestText
}
