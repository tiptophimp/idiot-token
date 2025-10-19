# Security Policy

## Supported Versions

We take the security of the IDIOT Token project seriously. The following versions are currently supported with security updates:

| Version | Supported          |
| ------- | ------------------ |
| 4.0.x   | :white_check_mark: |
| < 4.0   | :x:                |

## Reporting a Vulnerability

We appreciate your efforts to responsibly disclose your findings and will make every effort to acknowledge your contributions.

### How to Report a Security Vulnerability

**Please DO NOT report security vulnerabilities through public GitHub issues.**

Instead, please report security vulnerabilities by emailing:

**security@stupidiots.com**

You should receive a response within 48 hours. If for some reason you do not, please follow up via Discord to ensure we received your original message.

### What to Include in Your Report

Please include the following information in your report:

- Type of issue (e.g., buffer overflow, SQL injection, cross-site scripting, etc.)
- Full paths of source file(s) related to the manifestation of the issue
- The location of the affected source code (tag/branch/commit or direct URL)
- Any special configuration required to reproduce the issue
- Step-by-step instructions to reproduce the issue
- Proof-of-concept or exploit code (if possible)
- Impact of the issue, including how an attacker might exploit it

### Our Commitment

- We will acknowledge receipt of your vulnerability report within 48 hours
- We will provide an estimated timeline for a fix within 7 days
- We will notify you when the vulnerability is fixed
- We will credit you in our security acknowledgments (unless you prefer to remain anonymous)

## Security Best Practices

### For Users

1. **Never share your private keys** - We will never ask for your private keys
2. **Verify contract addresses** - Always verify the official IDIOT Token contract address: `0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`
3. **Use hardware wallets** - For large holdings, use hardware wallets like Ledger or Trezor
4. **Enable 2FA** - Enable two-factor authentication on all exchanges and wallets
5. **Beware of phishing** - Always verify URLs before connecting your wallet

### For Developers

1. **Keep dependencies updated** - Regularly update npm packages and dependencies
2. **Use environment variables** - Never commit sensitive data to the repository
3. **Code review** - All code changes must be reviewed before merging
4. **Test thoroughly** - Write comprehensive tests for all features
5. **Follow secure coding practices** - Use linters and security scanners

## Known Security Considerations

### Smart Contract

- The IDIOT Token smart contract has been deployed on Base network
- Contract address: `0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1`
- Liquidity pool: `0x763c9aB550dC0DAbd32F40131481Bf4BA4d8c1ea`
- All transactions are publicly verifiable on [BaseScan](https://basescan.org/token/0xC29EF04CFFe38012dcfc1E96a2B368443f298dE1)

### Website Security

- All user inputs are sanitized
- No sensitive data is stored client-side
- HTTPS is enforced on production
- Regular security audits are performed

## Security Updates

Security updates will be announced through:

1. **GitHub Security Advisories** - https://github.com/tiptophimp/idiot-token/security/advisories
2. **Discord Announcements** - https://discord.gg/idiottoken
3. **Twitter** - https://x.com/Stup_IDIOT_s
4. **Telegram** - https://t.me/idiottoken

## Bug Bounty Program

We are currently evaluating a bug bounty program. Details will be announced soon.

## Contact

For security-related inquiries:
- **Email:** security@stupidiots.com
- **Discord:** https://discord.gg/idiottoken
- **GitHub:** https://github.com/tiptophimp/idiot-token

For general inquiries:
- **Website:** https://stupidiots.com
- **Twitter:** https://x.com/Stup_IDIOT_s

---

**Last Updated:** October 19, 2025

Thank you for helping keep IDIOT Token and our community safe!

