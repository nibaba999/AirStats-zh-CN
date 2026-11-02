# Pulse integration record

AirStats includes source code from [Pulse](https://github.com/qunqin24/Pulse),
version 1.12.4, upstream commit
`13f0cf89775e1b88686cbd610a50a3f7bb2cdb65`. Pulse is distributed under the
Apache License 2.0; see `LICENSE`. Its third-party notices, including the Lobe
Icons MIT notice, are retained in `THIRD_PARTY_NOTICES.md`.

The Pulse application entry point was adapted for use as an internal Swift module
inside AirStats. In embedded mode, AirStats starts Pulse's monitoring and settings
features, suppresses Pulse's independent status item and login-item registration,
and routes its panel and settings requests through AirStats. Pulse supplies the
selected account's compact quota value and warning state to AirStats' native menu-bar
readout; its provider, account, alert and spend settings are hosted inside AirStats.
The embedded settings language follows AirStats' Chinese or English selection, and
controls for Pulse's suppressed standalone status item are hidden. Original per-file
copyright and license headers remain with the upstream source. Other changes are
documented in the source diff against the upstream commit above.

The optional animated Grok Bot mark is not included. Pulse's upstream notice records
that its geometry data was derived from a reference project that grants no licence.
To avoid redistributing unlicensed material, this adaptation keeps provider marks in
the usage rings and omits the animation data and its settings.

Pulse's Sparkle dependency is supplied by the host AirStats app bundle. The
standalone Pulse app is not bundled or required.
