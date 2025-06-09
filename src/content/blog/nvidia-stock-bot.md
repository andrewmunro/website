---
title: Nvidia Stock Bot
excerpt: I've built a bot to check for stock of a product on the Nvidia website.
publishDate: 'June 09 2025'
tags: [Computing, Hardware]
seo:
    image:
        src: '/nvidia-stock-bot/telegram.png'
        alt: Project preview
---

Frustrated with the lack of stock of the RTX 5090 on release day, I decided to build a bot to check for stock so I could beat those pesky scalpers...

It was the first time I've built a stock bot, and I spent all of 30 minutes piecing it together.

This simple script runs in a [GNU screen](https://www.gnu.org/software/screen/) session on my [homelab](/projects/homelab), and checks for stock every 5 seconds. When stock is found, it sends me a notification to my PC and phone via Telegram.

![Stock Bot](/nvidia-stock-bot/telegram.png)

I initially tried services like twilio to send myself a whatsapp message, but eventually dropped it as it seemed complex and wasn't free. I've built multiple discord bots in the past, but they can be quite fiddly and this seemed overkill for my use case... perhaps I'll pivot to a generic discord bot in the future if I have other products to buy.

To setup the telegram bot, you can [follow this guide](https://core.telegram.org/bots/tutorial).

```typescript
const telegramToken = process.env.TELEGRAM_TOKEN || '';
const telegramChatId = process.env.TELEGRAM_CHAT_ID || '';
const SKU = process.env.SKU || 'SCANNVGFFE5090';

if (!telegramToken || !telegramChatId) {
	console.error('Missing required environment variables: TELEGRAM_TOKEN and TELEGRAM_CHAT_ID');
	process.exit(1);
}

let sentText = false;

const checkForStock = async () => {
	const data = await fetch(`https://api.store.nvidia.com/partner/v1/feinventory?status=1&skus=${SKU}&locale=en-gb`, {
		headers: {
			accept: 'application/json',
			'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
			'cache-control': 'no-cache',
			'content-type': 'application/json',
		},
	});

	let url: any = null;

	// log out response
	try {
		const res = await data.json();
		url = res.listMap[0].product_url; // || testUrl;
	} catch (e) {
		console.log('failed to read response', e);
		sendTelegramNotification('Bot Failed :(');
		return;
	}

	if (url) {
		// decode url
		let decodedUrl = decodeURIComponent(url);
		console.log('STOCK FOUND!   ', decodedUrl);

		// open in browser
		if (process.platform === 'win32') {
			Bun.spawn(['cmd.exe', '/c', 'start', decodedUrl]);
		} else if (process.platform === 'darwin') {
			Bun.spawn(['open', decodedUrl]); // macOS
		}

		sendTelegramNotification(`\n${url}\n\nBuy now!`);

		clearInterval(interval);

		console.log('Pausing for 1 minute before checking again');
		setTimeout(() => {
			interval = setInterval(checkForStock, 5000);
		}, 60000);
	} else {
		console.error('Sold out');
	}
};

const sendTelegramNotification = async (message: string) => {
	if (sentText) return; // don't send multiple messages

	try {
		await fetch(`https://api.telegram.org/bot${telegramToken}/sendMessage`, {
			method: 'POST',
			headers: { 'Content-Type': 'application/json' },
			body: JSON.stringify({ chat_id: telegramChatId, text: message })
		});

		sentText = true;
	} catch (e) {
		console.error('Error sending telegram message:', e);
	}
};

// repeat every 5 seconds
checkForStock();
let interval = setInterval(checkForStock, 5000);
```