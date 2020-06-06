package extractor

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/suite"
)

type pdfExtractorTestSuite struct {
	suite.Suite
}

func (suite *pdfExtractorTestSuite) TestShouldRemoveTheNameOfTheCandidateWhenMentionedOnce() {
	result := PDFExtractor("test_data/ResumeWithOneMention.pdf")

	assert.NotContains(suite.T(), result, "Candidate Name")
	assert.NotContains(suite.T(), result, "Candidate")
	assert.NotContains(suite.T(), result, "Name")
}

func TestPDFExtractorTestSuite(t *testing.T) {
	suite.Run(t, new(pdfExtractorTestSuite))
}
