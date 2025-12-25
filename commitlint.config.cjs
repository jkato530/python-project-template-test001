module.exports = {
  extends: ['@commitlint/config-conventional'],
  plugins: [
    {
      rules: {
        'header-regex': ({ header }) => {
          const separator = ' / ';

          // 区切り文字がない場合または日本語部分が空の場合
          if (!header.includes(separator)) {
            return [
              false,
              "Header must be in 'English / Japanese' format with ' / ' separator.\n" +
              "ヘッダーは '英語 / 日本語' の形式で、間に ' / ' (スペース+スラッシュ+スペース) を入れてください"
            ];
          }

          const splitIndex = header.indexOf(separator);
          const englishPart = header.substring(0, splitIndex);
          const japanesePart = header.substring(splitIndex + separator.length);

          // 英語部分の形式チェック
          const englishRegex = /^[a-z]+(?:\([a-z0-9-]+\))?: [ -~]+$/;
          if (!englishRegex.test(englishPart)) {
            return [
              false,
              `The English part must contain only ASCII characters and follow 'type: description' format.\n` +
              `英語部分（前半）に全角文字が含まれているか、形式が "type: description" になっていません。\n` +
              `Target/対象: "${englishPart}"`
            ];
          }

          // 日本語部分に別のヘッダーが含まれていないかチェック
          const anotherHeaderRegex = /[a-z]+(?:\([a-z0-9-]+\))?:/;
          if (japanesePart.includes(separator) || anotherHeaderRegex.test(japanesePart)) {
            return [
              false,
              'The Japanese part of the header appears to contain another commit message. Please ensure the header contains only one commit message.\n' +
              'ヘッダーの日本語部分に、別のコミットメッセージが含まれているようです。ヘッダーには単一のメッセージのみを記述してください。'
            ];
          }

          return [true];
        },
        'body-no-multi-header': ({ body }) => {
          if (!body) {
            return [true];
          }
          const englishHeaderRegex = /^[a-z]+(?:\([a-z0-9-]+\))?: [ -~]+$/;
          const separator = ' / ';

          const lines = body.split('\n');
          for (const line of lines) {
            let cleanLine = line.trim();
            // Check for list markers like '-' or '*'
            if (cleanLine.startsWith('- ') || cleanLine.startsWith('* ')) {
              cleanLine = cleanLine.substring(2);
            }

            if (cleanLine.includes(separator)) {
              const splitIndex = cleanLine.indexOf(separator);
              const englishPart = cleanLine.substring(0, splitIndex);
              if (englishHeaderRegex.test(englishPart)) {
                return [
                  false,
                  'The commit body seems to contain another commit message. Please split into multiple commits or consolidate the message.\n' +
                  'コミットボディに別のコミットメッセージが含まれているようです。コミットを分割するか、メッセージを1つにまとめてください。'
                ];
              }
            }
          }
          return [true];
        }
      }
    }
  ],
  rules: {
    'header-regex': [2, 'always'],
    'body-no-multi-header': [2, 'always'],
    'header-max-length': [2, 'always', 150]
  }
};
