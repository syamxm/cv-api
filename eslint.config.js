const js = require('@eslint/js');

module.exports = [
  js.configs.recommended,
  {
    files: ['src/**/*.js'],
    languageOptions: {
      sourceType: 'commonjs',
      globals: {
        require: 'readonly',
        module: 'writable',
        process: 'readonly',
        __dirname: 'readonly',
        console: 'readonly',
      },
    },
  },
  {
    files: ['public/**/*.js'],
    languageOptions: {
      globals: {
        window: 'readonly',
        document: 'readonly',
        fetch: 'readonly',
        console: 'readonly',
        localStorage: 'readonly',
        URLSearchParams: 'readonly',
        mountOnLoad: 'readonly',
        displayUrl: 'readonly',
        formatDateRange: 'readonly',
        groupByCategory: 'readonly',
        projectLinks: 'readonly',
      },
    },
  },
  {
    files: ['public/shared.js'],
    rules: {
      'no-unused-vars': 'off',
    },
  },
];
