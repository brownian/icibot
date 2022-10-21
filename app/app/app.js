/**
 * hi there
 * 
 * https://api.telegram.org/bot<token>/sendMessage?chat_id=<group chat id >&text=<our text>
 *
 */

// @ts-check

'use strict'

const { config } = require('./config')
const { logger } = require('./logger')

const TelegramBot = require('node-telegram-bot-api')

const token = config.bot.apikey

// Create a bot that uses 'polling' to fetch new updates
const bot = new TelegramBot(token, {polling: true})

// Matches "/echo [whatever]"
bot.onText(/^\/echo (.+)/, (msg, match) => {
  const chatId = msg.chat.id

  var resp;
  if ( match ) {
    resp = match[1]; // the captured "whatever"
  } else {
    resp = "(nothing)"
  }

  // send back the matched "whatever" to the chat
  bot.sendMessage(chatId, resp)
})

// Listen for any kind of message. There are different kinds of
// messages.
bot.on('message', (msg) => {
  const chatId = msg.chat.id

  logger.debug(`${chatId}: ${msg.text}`, { label: "TBOT" })

  // send a message to the chat acknowledging receipt of their message
  bot.sendMessage(chatId, '[No chat, no commands accepted]')
})

/***
bot.on('polling_error', (error) => {
  logger.debug(error.name, { label: "TBOT" });  // => 'ETELEGRAM'
  logger.debug(error.message, { label: "TBOT" }); // => { ok: false, error_code: 400, description: 'Bad Request: chat not found' }
})
*/