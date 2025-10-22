module.exports = {
  openai: {
    baseURL: 'https://api.openai.com/v1',
    models: {
      imageAnalysis: 'gpt-4o-mini',
      chat: 'gpt-4.1-mini',
      homework: 'gpt-4.1-mini',
      default: 'gpt-4.1-mini'
    },
    model: 'gpt-4.1-mini',
    maxTokens: 4000,
    temperature: 0.2
  }
};


