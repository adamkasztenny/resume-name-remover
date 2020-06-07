package extractor

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
)

type pdfExtractorTestSuite struct {
	suite.Suite
}

func (suite *pdfExtractorTestSuite) TestShouldRemoveTheNameOfTheCandidateWhenMentionedOnce() {
	file := suite.readFile("../test_data/ResumeWithOneMention.pdf")
	defer file.Close()

	result, err := PDFExtractor(file)
	assert.Nil(suite.T(), err)

	assert.NotContains(suite.T(), result, "Candidate Name")
	assert.NotContains(suite.T(), result, "Candidate")
	assert.NotContains(suite.T(), result, "Name")
}

func (suite *pdfExtractorTestSuite) TestShouldPreserveAllTextOtherThanTheCandidateName() {
	file := suite.readFile("../test_data/ResumeWithOneMention.pdf")
	defer file.Close()

	result, err := PDFExtractor(file)
	assert.Nil(suite.T(), err)

	assert.Contains(suite.T(), result, "100 Derp Avenue")
	assert.Contains(suite.T(), result, "(555) 555 5555")
	assert.Contains(suite.T(), result, "derp@example.com")

	assert.Contains(suite.T(), result, "Education")
	assert.Contains(suite.T(), result, "PhD in Derping")
	assert.Contains(suite.T(), result, "BS in Blorpology")

	assert.Contains(suite.T(), result, "Experience")
	assert.Contains(suite.T(), result, "Chief Derping Officer")
	assert.Contains(suite.T(), result, "Senior Derper")

	assert.Contains(suite.T(), result, "Skills")
	assert.Contains(suite.T(), result, "Golang")
	assert.Contains(suite.T(), result, "PDFs")
}

func (suite *pdfExtractorTestSuite) readFile(filename string) *os.File {
	file, err := os.Open(filename)
	assert.Nil(suite.T(), err)
	return file
}

func TestPDFExtractorTestSuite(t *testing.T) {
	suite.Run(t, new(pdfExtractorTestSuite))
}
