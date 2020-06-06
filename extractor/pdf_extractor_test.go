package extractor

import (
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
