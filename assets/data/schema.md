# WisdomSutra Data Schema

This document describes the JSON data structure used in the WisdomSutra app.

## Questions Data Structure

Questions are stored in language-specific JSON files (e.g., `questions_en.json`, `questions_gu.json`, etc.).

### Format
```json
[
  "Question text 1",
  "Question text 2",
  "Question text 3"
]
```

### Field Descriptions
- **Array of Strings**: Each element is a question that users can select to receive wisdom guidance.
- Questions are displayed in the questions screen for users to choose from.
- Each language file contains the same set of questions translated into that specific language.

### Available Languages
- `questions_en.json` - English
- `questions_gu.json` - Gujarati
- `questions_hi.json` - Hindi
- `questions_mr.json` - Marathi
- `questions_bn.json` - Bengali

### Example
```json
[
  "How will my wish be fulfilled?",
  "What should I do about money?",
  "What is the outcome of travel?",
  "What is the state of my health?"
]
```

## Answers Data Structure

Answers are stored in `answers.json` and are mapped to pattern combinations.

### Format
```json
{
  "pattern": {
    "language_code": "Answer text"
  }
}
```

### Field Descriptions
- **pattern** (String): A comma-separated string representing a 4-slot parity pattern
  - Each slot can be either `1` (odd) or `2` (even)
  - Pattern format: `"slot1,slot2,slot3,slot4"`
  - Example: `"1,2,2,1"`
  
- **language_code** (String): Two-letter language code
  - `"en"` - English
  - `"gu"` - Gujarati
  - `"hi"` - Hindi
  - `"mr"` - Marathi
  - `"bn"` - Bengali
  
- **Answer text** (String): The wisdom message associated with that pattern and language

### Pattern Generation Logic
1. User selects a question
2. User taps 4 times on the pattern wheel
3. Each tap is classified as odd (1) or even (2)
4. The resulting pattern is used to look up the answer

### Example
```json
{
  "1,2,2,1": {
    "en": "Your fortune looks bright."
  },
  "1,1,2,1": {
    "en": "Focus your mind; clarity brings reward."
  },
  "2,2,2,2": {
    "en": "Patience first, results will ripen soon."
  },
  "1,2,1,2": {
    "en": "Balance action with rest."
  }
}
```

## Usage in the App

1. **Questions Screen**: Loads questions from the appropriate language file based on user's language preference
2. **Pattern Picker Screen**: User taps to generate a 4-slot pattern
3. **Answer Screen**: Uses the generated pattern to lookup the corresponding answer from `answers.json`

## Extending the Data

### Adding New Questions
Add the question text to all language-specific question files to maintain consistency across languages.

### Adding New Answers
Add new pattern combinations to `answers.json`. Each pattern should have answers in all supported languages.

### Adding New Languages
1. Create a new `questions_XX.json` file (where XX is the language code)
2. Translate all questions
3. Add translations for all patterns in `answers.json`
