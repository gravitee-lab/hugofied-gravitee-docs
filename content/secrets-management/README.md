

## Secrethub and Binary files

secrethub under the hood uses http :
* so all secrets must be sent as pure text
* therfore, for all binary secret files such as the gravitee licnese, the file must be base 64 encoded before sent to secrethub, and then base64 decoded when retireved back from secrethub
