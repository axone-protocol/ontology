# Axone Ontology Changelog

## [4.0.0](https://github.com/axone-protocol/ontology/compare/v3.0.0...v4.0.0) (2024-08-07)


### ⚠ BREAKING CHANGES

* **ontology:** change URI domain from okp4 to axone
* **schema:** redesign the Service Execution order & results
* **schema:** remove SubSection hierarchy

### Features

* **example:** update examples ([4433c38](https://github.com/axone-protocol/ontology/commit/4433c38e6bfdb53c314c15eb1bc37f411bf51490))
* **example:** update uuid ([d73394f](https://github.com/axone-protocol/ontology/commit/d73394fae8d5a7470b80062b0c384ecedddfa3e5))
* remove exec order ref from auth credential ([0e11bb9](https://github.com/axone-protocol/ontology/commit/0e11bb9a366a3cbc4425ea1d4193692f5b99bf49))
* **schema:** add digital-resource-publication credentials schema ([b9490ff](https://github.com/axone-protocol/ontology/commit/b9490ff887a0c8eabf41563de357121423e48317))
* **schema:** add hasExecutionEvidence prop to OrchestrationServiceExecution ([681afd6](https://github.com/axone-protocol/ontology/commit/681afd66574ff8a3f8705a0abd45f8c01d58e40d))
* **schema:** add new credential to represents auth between services ([a6e3e4e](https://github.com/axone-protocol/ontology/commit/a6e3e4ef00c38eac6753247b8fbfe70bc7becc3e))
* **thesaurus:** specify InExecution term ([f2756bd](https://github.com/axone-protocol/ontology/commit/f2756bd87715e8ec0bd633bfa124a128c6edff2c))


### Bug Fixes

* correct some orchestration creds property domain ([41aabd1](https://github.com/axone-protocol/ontology/commit/41aabd1350effb7873b7f8eee6ece48002f6ea74))
* **example:** change type credential ([c86c592](https://github.com/axone-protocol/ontology/commit/c86c5922b43edc0d0b7790600973cb8721271d58))
* **example:** correct prolog governance ([354ea76](https://github.com/axone-protocol/ontology/commit/354ea762d7093b333a8cd6072cc8a301b16187cf))
* **example:** remove subsection into gov VC examples ([f093d2c](https://github.com/axone-protocol/ontology/commit/f093d2cf3507898ffa0dd5a905a12e5d9bc2253e))
* **example:** update uuid ([eaa6ef5](https://github.com/axone-protocol/ontology/commit/eaa6ef54c941b3ac8663b4a785281d5aeef9405e))
* **schema:** correct grammar ([81bcf07](https://github.com/axone-protocol/ontology/commit/81bcf070aac5322ee5fbb8a9fc2066d70c064caf))
* **schema:** fix typos ([24fb40a](https://github.com/axone-protocol/ontology/commit/24fb40acbeae7c6701975ba5e7c6d3af9b0e41e0))
* **script:** add property domain (was missing) ([4f8b27a](https://github.com/axone-protocol/ontology/commit/4f8b27a9ea932aedc1ec6e56abcc71a38705f3b6))
* **script:** fix plural form ([cd433a1](https://github.com/axone-protocol/ontology/commit/cd433a172b06260b8b59cf5195da8aa28ea5cc7c))


### Code Refactoring

* **ontology:** change URI domain from okp4 to axone ([f4887ab](https://github.com/axone-protocol/ontology/commit/f4887ab66540663fdc4f83020b7a7d496b87b3dc))
* **schema:** redesign the Service Execution order & results ([7b7b66d](https://github.com/axone-protocol/ontology/commit/7b7b66dfa7c6ca5e5e3b1bc081dfda04bf319a15))
* **schema:** remove SubSection hierarchy ([c3cdd78](https://github.com/axone-protocol/ontology/commit/c3cdd78f90cfcbb24c3984ba33f5b99a1addd176))

# OKP4 Ontology Changelog

## [3.0.0](https://github.com/okp4/ontology/compare/v2.0.0...v3.0.0) (2024-03-05)


### ⚠ BREAKING CHANGES

* **project:** generate flatten json-ld schemas
* **schema:** fix typo in class name
* **schema:** remove credential zone declaration credential
* **release:** remove json-ld artifact
* **schema:** remove credential-x-declaration claims

### Features

* add service webpage property ([0a71d52](https://github.com/okp4/ontology/commit/0a71d52fc55c0300a76a3fffdc3cce2d8529ac85))
* **example:** add Collab AI zone governance VC ([4c52978](https://github.com/okp4/ontology/commit/4c5297833c5b238d5ecb1bd53545b24bb8c987b2))
* **example:** add collaborative ai zone ([0b8eebf](https://github.com/okp4/ontology/commit/0b8eebfb3d5ef67d4bd03435e6be2c407b5fab40))
* **example:** add crime dataset description ([ccf4bcf](https://github.com/okp4/ontology/commit/ccf4bcfcb3edbe9bff90ce3cd33bbe97c9842d6c))
* **example:** add crime dataset governance VC ([4a43f0c](https://github.com/okp4/ontology/commit/4a43f0c35e64c44f350a95a2308d6473cab45fe8))
* **example:** add ipfs storage VC ([dc2fde3](https://github.com/okp4/ontology/commit/dc2fde348205493780fcc0eb17cf5cc2935ff19b))
* **example:** add keyring used by example VCs ([0aea79a](https://github.com/okp4/ontology/commit/0aea79a3b4a993abb4a270d8a6acf1dbb872a5b3))
* **example:** improve description of example VCs ([afa1810](https://github.com/okp4/ontology/commit/afa181062447ef2cbe40e8ca2fb1161d7a5eb20f))
* **example:** rename ipfs digital service description file ([fa32f2a](https://github.com/okp4/ontology/commit/fa32f2ab77c3c0f2b9e5023fdf69506cfa7d345b))
* **schema:** add dataset-description credentials schema ([c9d1c35](https://github.com/okp4/ontology/commit/c9d1c35d487ab5fb032e4a2a1988ad18f7ecfc2c))
* **schema:** add digital service execution order credentials schema ([c098e09](https://github.com/okp4/ontology/commit/c098e099de3c3974659559274555638af233af11))
* **schema:** add digital-resource-registration credentials schema ([78a727f](https://github.com/okp4/ontology/commit/78a727f314d21558d170d140e2d527e5d8268641))
* **schema:** add digital-resource-rights credentials schema ([b9e3159](https://github.com/okp4/ontology/commit/b9e315985e0057827ff59cc296f4daa63e0d9c58))
* **schema:** add digital-service-description credentials schema ([7afa260](https://github.com/okp4/ontology/commit/7afa2601378666b386e75f9e7de10e4a141f437e))
* **schema:** add digital-service-execution-result credential ([4c320b1](https://github.com/okp4/ontology/commit/4c320b1c70bb120ac3687c454831ab802588161e))
* **schema:** add digital-service-registration credentials schema ([33c85a7](https://github.com/okp4/ontology/commit/33c85a7b23f90f9efdfac8a64aa598818c67b213))
* **schema:** add governance-text credentials schema ([61235bc](https://github.com/okp4/ontology/commit/61235bc19f81b3d369ad378730197a1724f59301))
* **schema:** add zone-description credentials schema ([6abcd35](https://github.com/okp4/ontology/commit/6abcd352f00e663f8c7192ccf340ef8200e7e5cd))
* **schema:** add zone-registration credentials schema ([046c57e](https://github.com/okp4/ontology/commit/046c57e0df13ee75ccae7768c018f5586ed40380))
* **schema:** improve description of the Resources ([4f9889a](https://github.com/okp4/ontology/commit/4f9889aa72f2b169f4d5ad01ce0b1968822448f8))
* **schema:** remove credential zone declaration credential ([a64d0d3](https://github.com/okp4/ontology/commit/a64d0d3cebc4b6b2899b070a643169049c7f4360))
* **thersaurus:** add digital-service-execution-status thesaurus ([3f96024](https://github.com/okp4/ontology/commit/3f9602474435983c6d8ca991655c0e7a2f132ea8))
* **thesaurus:** add Security concept to topics ([f3c5840](https://github.com/okp4/ontology/commit/f3c58403317762baf70003862e76e3e0c5af8e54))


### Bug Fixes

* apply suggestions after code review ([edf4f30](https://github.com/okp4/ontology/commit/edf4f30f43291fcc3235a4096a3c79423a71f314))
* **example:** correct thesaurus URI ([2bbd685](https://github.com/okp4/ontology/commit/2bbd685b4d2dd4519e4b0d66c11c3e46e271f011))
* **example:** correct URI credential ([39bfe1f](https://github.com/okp4/ontology/commit/39bfe1fb547cef8c3dae1307eac7e0ea52205518))
* format file in ttl ([4f93b8a](https://github.com/okp4/ontology/commit/4f93b8a27a3831e49a290dd6d9141c9637854861))
* **schema:** fix incorrect class name in rangeIncludes ([2f54e74](https://github.com/okp4/ontology/commit/2f54e743bdd6cb142fc2297366bbd03b49d38b05))
* **schema:** fix namespaces (was missing end slash) ([1eb1bdf](https://github.com/okp4/ontology/commit/1eb1bdf8b977b7fb59eca52ed50f84ecb30e2497))
* **schema:** fix typo in class name ([cc7f6c5](https://github.com/okp4/ontology/commit/cc7f6c57f28070df7a0fb5ed190f55a9a79e79eb))
* **schemas:** fix incorrect label ([5242aaa](https://github.com/okp4/ontology/commit/5242aaa5fa580ea4914b13073baa3af4bc71fd40))
* **schema:** standardize naming & namespaces ([e328069](https://github.com/okp4/ontology/commit/e328069f05bfc62cabb6f6e370972f3c6787dd11))
* **thesaurus:** fix typo in rdf:property ([6cbfb50](https://github.com/okp4/ontology/commit/6cbfb50e4349f17d460ef9e2b7294b8074bf494d))
* **thesaurus:** standardize naming & namespace ([d5f8c65](https://github.com/okp4/ontology/commit/d5f8c65737ac88769606a5823b0a74fe4963aaa6))


### Code Refactoring

* **schema:** remove credential-x-declaration claims ([8c15177](https://github.com/okp4/ontology/commit/8c15177af79a3a8d816c6122ccf2ca5edf9d9620))


### Build System

* **project:** generate flatten json-ld schemas ([454d1ef](https://github.com/okp4/ontology/commit/454d1ef5a924dab50461335edf75e97ffe1a5167))


### Continuous Integration

* **release:** remove json-ld artifact ([8f76641](https://github.com/okp4/ontology/commit/8f7664163978867037aa7f261ec490c275f91137))

## [2.0.0](https://github.com/okp4/ontology/compare/v1.1.2...v2.0.0) (2023-11-20)


### ⚠ BREAKING CHANGES

* remove okp4:core subclassification of resources
* turn wasCreatedBy property into annotation
* reverse the membership relation

### Features

* add area thesaurus ([3b0bc50](https://github.com/okp4/ontology/commit/3b0bc50a5d5b76dde36a3f544e8984052e0c5cb7))
* add cads governance ([881e1f3](https://github.com/okp4/ontology/commit/881e1f3e5ff5b50f880bc598a9f85c166f5b6427))
* add content to metadata files ([1a870d0](https://github.com/okp4/ontology/commit/1a870d0d38502cc7d503ffee75e97f3b6c493458))
* add ds4i governance ([90da852](https://github.com/okp4/ontology/commit/90da85236cf3de54ca03f14ca6426b9d3fbb89a0))
* add english and german translations title to dataset ([c601c25](https://github.com/okp4/ontology/commit/c601c2509e22dfff62567e2792e1ab5e4105d6a6))
* add examples governance metadata description ([8d44ed3](https://github.com/okp4/ontology/commit/8d44ed3001e405db0914b8a466a101a067c7d31f))
* add geopackage+sqlite3 ([7e3f2d5](https://github.com/okp4/ontology/commit/7e3f2d57e871bdb2d4d9776f39d323937d7cef45))
* add governance ([f59e77d](https://github.com/okp4/ontology/commit/f59e77d5d7815235332ad8a02339d867addb0cb6))
* add governance metadata description ([ab3a655](https://github.com/okp4/ontology/commit/ab3a655616c000e0780cbd977ba44eb96a6b0866))
* add hasIdentity property ([3f2e132](https://github.com/okp4/ontology/commit/3f2e132ed7f059d8efc93bd0454836229500b9dc))
* add hasImage property ([6abde27](https://github.com/okp4/ontology/commit/6abde27469b27acac61f29ce5330390d08f74da7))
* add hasPublisher property ([f4093dc](https://github.com/okp4/ontology/commit/f4093dc45605c5d9c638e712584dcadb4797824c))
* add identity and governance model section ([26d957d](https://github.com/okp4/ontology/commit/26d957d5ffb26f812cdb5609bab35524beae3dd4))
* add license controlled vocabulary ([020530c](https://github.com/okp4/ontology/commit/020530cd41b25ccd36578a29e7610a4bcb4dfa15))
* add open licence v1 ([566f892](https://github.com/okp4/ontology/commit/566f892b121eaeeb269c0e885fa47a2104299b5f))
* add Open Licence version 1.0 to dataLicences collection ([62daa41](https://github.com/okp4/ontology/commit/62daa414af1d61c7a0c0da23711ce2c7691d6784))
* add providedBy property ([da4b94b](https://github.com/okp4/ontology/commit/da4b94bb4de403ccec6cc9d681a81031cbaa26f9))
* add reference dataset subsection ([0a8bdaa](https://github.com/okp4/ontology/commit/0a8bdaa671386c60dfc7826880f8f30895107b6a))
* add Service concept ([0dd8272](https://github.com/okp4/ontology/commit/0dd827273d1361eebe78a339e954762bdafb770e))
* add Service in the union of resources ([901d4a1](https://github.com/okp4/ontology/commit/901d4a164612ed983b1cc11170476407c4dd4859))
* add service management and buisiness section ([268ae69](https://github.com/okp4/ontology/commit/268ae69377042a5ddf8382da23ab3820187bcf89))
* add storage services metadata ([067a52a](https://github.com/okp4/ontology/commit/067a52a76c3bfca8c6f0e62aa0af1ad9165e2ece))
* add text_csv to text collection ([8435c91](https://github.com/okp4/ontology/commit/8435c9130e13582b4f117c03f25bd6c7606baf6e))
* add the Service Category thesaurus ([86de145](https://github.com/okp4/ontology/commit/86de145655a76115b56df5a27da04befdaad3276))
* add the Topic thesaurus ([48c33ee](https://github.com/okp4/ontology/commit/48c33eeb38a20d6c6a21785b5adf49a261e2fbc1))
* add vndshp to collection ([8788a09](https://github.com/okp4/ontology/commit/8788a09563f083754151b3bf0798928d4238dbf7))
* **core:** add audit related properties ([e62537c](https://github.com/okp4/ontology/commit/e62537cbe5ad465a7f89f00a16ea0b7b64377b5c))
* **core:** add DIDURI concept and hasRegistrar property ([56eb4af](https://github.com/okp4/ontology/commit/56eb4af6277ad06205efafc650034d6214cbb715))
* **core:** add hasCategory core property ([1fd328a](https://github.com/okp4/ontology/commit/1fd328ae726883f8c3fbdc277e96f05ea931b0b9))
* **core:** add hasFormat property ([2fe325a](https://github.com/okp4/ontology/commit/2fe325ad720da68038e9c1d1bcf67e2e0f6a163d))
* **core:** add hasIdentifier property ([83a3432](https://github.com/okp4/ontology/commit/83a34323f0aa5635fb8e432991c1618e1fa6b4e1))
* **core:** add hasRegistrar property to dataspace ([96561b2](https://github.com/okp4/ontology/commit/96561b21404d4b11cd63c99a0084786897b850c2))
* **core:** add hasRegistrar to Dataset ([a79d2c8](https://github.com/okp4/ontology/commit/a79d2c863c88a2de94c5ce5dad11a6a42d901586))
* **core:** add Service execution concepts ([6da9e05](https://github.com/okp4/ontology/commit/6da9e055b9cf0b195eaad78b66a471c0c3876ea0))
* **core:** add the concept of Governance ([9aed033](https://github.com/okp4/ontology/commit/9aed0332391f3e2b30d855f6d566a1b36d1e7ec0))
* datasets management section completion ([af2b1df](https://github.com/okp4/ontology/commit/af2b1dfec356ad12b2446bd0e17c0e2a7c83a631))
* **example:** add ddp and crop zones metadatagit ([91790de](https://github.com/okp4/ontology/commit/91790de779092ec6dcb3fd6f46277318bfb1cbda))
* improve translation mediatypes thesaurus ([75fb245](https://github.com/okp4/ontology/commit/75fb24569444a8c9ceb50c7ca277c3614e6e6293))
* **metadata:** add DataProcessing broader concept ([531c48c](https://github.com/okp4/ontology/commit/531c48ceb46b29f369b30588d992c8073efe672f))
* **metadata:** add general metadata for Service ([0c8e64b](https://github.com/okp4/ontology/commit/0c8e64bad25bc231579277c2ced80759e99a207a))
* **metadata:** add general metadata specification for dataspaces ([fdc4041](https://github.com/okp4/ontology/commit/fdc404109a242e89b9caca8ad7e1e9fdf9f997df))
* **metadata:** add hasFormat property to dataset meta ([4faf887](https://github.com/okp4/ontology/commit/4faf887bedf82eba216734482771af07d67a2579))
* **metadata:** add metadata governance schema ([eb1c49c](https://github.com/okp4/ontology/commit/eb1c49cbce4f6bee865284970aba369d2e1479e4))
* **metadata:** add Storage concept ([b0e8ffb](https://github.com/okp4/ontology/commit/b0e8ffba5767ae2c196d282fc8be88850854a8e0))
* specify GeneralMetadata class ([ae1a113](https://github.com/okp4/ontology/commit/ae1a1136d7cbe3d2c2dc268aad2df9f5758553a0))
* specify hasCreator property ([eca4f2b](https://github.com/okp4/ontology/commit/eca4f2b28aa2da5292d6bb9386a16bc60a857123))
* specify hasDescription property ([9b4a7c0](https://github.com/okp4/ontology/commit/9b4a7c08dca33b61851dbc9b6a9fe7234b22f6e7))
* specify hasLicense property ([135030b](https://github.com/okp4/ontology/commit/135030b1f88243ae7e4a8a1aef62b6dc5eb77caa))
* specify hasSpatialCoverage property ([34571de](https://github.com/okp4/ontology/commit/34571de7ef74673f02a9acfabdae4de66dcfd9ad))
* specify hasTag property ([a57039d](https://github.com/okp4/ontology/commit/a57039dd9e3663fcc7d519fd01eeadeab615dab0))
* specify hasTemporalCoverage property ([1c9cee9](https://github.com/okp4/ontology/commit/1c9cee9184d87704adcfbaddf5dac28e56719d66))
* specify hasTitle property ([9a08fd7](https://github.com/okp4/ontology/commit/9a08fd7448bc97c1e7f552e2931d190004856174))
* specify hasTopic property ([baf2af2](https://github.com/okp4/ontology/commit/baf2af2981fb30f70d5c9ad94c7fa292794973b2))
* specity Period class (and related properties) ([2a84d08](https://github.com/okp4/ontology/commit/2a84d0878833f9394877cd7c2d5c33dd934d4ce2))
* translate area thesaurus in french ([2dfe188](https://github.com/okp4/ontology/commit/2dfe188674469d21495490b8d213ef21156b6842))
* translate service category thesaurus ([9957c86](https://github.com/okp4/ontology/commit/9957c86b49b2108cb05ea71dac0c222446fc954e))
* translate topic thesaurus ([1104fd4](https://github.com/okp4/ontology/commit/1104fd455dd6ec6eb7f190f6b0598772d9518d55))
* translation storage services ([21f8fc7](https://github.com/okp4/ontology/commit/21f8fc72cbade94eb0c7ea8d0c2857552af66ec0))
* update examples of zones ([f9cded2](https://github.com/okp4/ontology/commit/f9cded2d9afcaa4a11fe8af3bd799f4ca604d0bf))
* update examples of zones bis ([6edf718](https://github.com/okp4/ontology/commit/6edf718aba80db2838ad8caceebd96219f0814fd))
* update governane after review ([d7de2ed](https://github.com/okp4/ontology/commit/d7de2ed237651ad273ec9a4c920168912772a00d))
* update paragraph description ([2d3caa5](https://github.com/okp4/ontology/commit/2d3caa5d49fa593988d0b5ebad93887cab541ca0))
* update paragraph description ([6cc9405](https://github.com/okp4/ontology/commit/6cc9405b2bfe0229ee4e4f2808cf0975a8ed2cec))
* update paragraph description ([8df95e4](https://github.com/okp4/ontology/commit/8df95e44a35d056d67aa386b165662d3689a97b9))
* **vocabulary:** add audit vocabulary ([746d059](https://github.com/okp4/ontology/commit/746d059fc70f7a4b0242f74bff1b1c9076100d86))
* **vocabulary:** add mediatype controlled vocabulary ([498c356](https://github.com/okp4/ontology/commit/498c356a33d3f0d910b9a5825a1d1d53dca49da0))
* **vocabulary:** add text/csv term ([3b35822](https://github.com/okp4/ontology/commit/3b35822f95af42f6485195cf4ca988f5afa4dc23))
* **vocabulary:** improve thesaurus description and definition ([a2b6c33](https://github.com/okp4/ontology/commit/a2b6c3366d006960c11eff04c3c92867515e3d68))


### Bug Fixes

* **cads:** update metadata ids ([66af561](https://github.com/okp4/ontology/commit/66af56148a8bada0fa4a6af1396a29538016c813))
* change vnd-shp to vndshp ([ebfaa35](https://github.com/okp4/ontology/commit/ebfaa35d4bcb05742ec80c3febc6501313f46796))
* change zones governance descriptions ([0870ab2](https://github.com/okp4/ontology/commit/0870ab2b762f1eded06dbe2fb66520be91ea1a52))
* **core:** correct incorrect range definition for skos vocabularies ([65af993](https://github.com/okp4/ontology/commit/65af993c137f7be8ae0a9b8d8084c29d07df53aa))
* correct dataspace uuid ([e2c9856](https://github.com/okp4/ontology/commit/e2c9856d491bdde4e12bef05c75debbbca9e1123))
* correct some uuid ([6835699](https://github.com/okp4/ontology/commit/683569924b870545a6eeb9ff3ec659fcbeb17bee))
* **examples:** fix wrong topic ([60d923d](https://github.com/okp4/ontology/commit/60d923d4d6de61810da1aba30f064499716f8a4e))
* extends AgricutureEnvironnementAndForestry topic to food ([588459c](https://github.com/okp4/ontology/commit/588459c65b029e5f3f1318deb55bf88d596f91d1))
* fix cardinality ([3c246b5](https://github.com/okp4/ontology/commit/3c246b58ab5c61e306b8d7372fac1384b361f558))
* fix typo in Dataset description ([b749366](https://github.com/okp4/ontology/commit/b7493664c10448760deddbc74eff4309be7a32f2))
* fix typo in label ([c9b1e7d](https://github.com/okp4/ontology/commit/c9b1e7d4f08a6f4546f423da38da4c9ef422aefa))
* geopackage-sqlite3 to geopackagesqlite3 ([b24e882](https://github.com/okp4/ontology/commit/b24e8828518c6e969d0a5550b1254f08ad506483))
* **governance:** fix incorrect uuid ([eb42dc3](https://github.com/okp4/ontology/commit/eb42dc33a84956db3735a7d6638aa3aad72c3a47))
* **governance:** specify language for description and title ([30f6327](https://github.com/okp4/ontology/commit/30f6327a483182499ce28a1a914631015cdcc512))
* **lint-ontology:** correct syntax ([9a53cc8](https://github.com/okp4/ontology/commit/9a53cc8f33f580dcdab8525d6535615ae87efeaf))
* **metadata:** correct restrictions to skos vocabularies ([4aa380c](https://github.com/okp4/ontology/commit/4aa380cba33abc93775d6de3d698578905705362))
* **metadata:** fix typo in description ([5d23d24](https://github.com/okp4/ontology/commit/5d23d24af6a6699777ad457af21d1496689f59ee))
* **release:** rearrange conventionalcommits preset ([2f1f547](https://github.com/okp4/ontology/commit/2f1f547576c7199581c74a54616e250df7680b45))
* **release:** remove commit-analyser release rules ([33fe1a3](https://github.com/okp4/ontology/commit/33fe1a3c4ced32b05e4a68cfc1b4bb2c131d7a4f))
* remove governance metadata description ([561f099](https://github.com/okp4/ontology/commit/561f0990fc377d077dee824f089ba54f2b22023b))
* shapefile to application_vndshp ([07d3fe6](https://github.com/okp4/ontology/commit/07d3fe6f7aea4f1fe2c0e0f857f11c0b4335a559))
* syntax ([7187e75](https://github.com/okp4/ontology/commit/7187e75ec61dbd812739f40d2c50176123aaffb3))
* **test:** resolve non-compliant examples and ensure green tests ([ce5782c](https://github.com/okp4/ontology/commit/ce5782c2d17ad36e2fb291cf43982cf37a6e5b63))
* typo in the folder name Rhizome ([6e09adc](https://github.com/okp4/ontology/commit/6e09adcc1aaf7e10055c8967bcd8257ea4f97102))
* update deutsch title with de language ([5497eab](https://github.com/okp4/ontology/commit/5497eab71edd182d59c14d14e0348d76877ab00f))
* update of the AgricultureEnvironmentAndForestry topic to AgricultureFoodEnvironmentAndForestry ([446e700](https://github.com/okp4/ontology/commit/446e70013fbea363f912d913e8572d12f552d318))
* **vocab-mediatype:** fix wrong license prefix ([85d164a](https://github.com/okp4/ontology/commit/85d164a50d08effb8f480bf3ce047910303fac07))


### Code Refactoring

* remove okp4:core subclassification of resources ([0a1587f](https://github.com/okp4/ontology/commit/0a1587f91d720f4259802809869b6e1738782276))
* reverse the membership relation ([872f13a](https://github.com/okp4/ontology/commit/872f13af1f49dbd5bed248df55aace45b67a42b1))
* turn wasCreatedBy property into annotation ([4d5c336](https://github.com/okp4/ontology/commit/4d5c3366811a34bcbd9163d8851992658de5600e))

## [1.1.2](https://github.com/okp4/ontology/compare/v1.1.1...v1.1.2) (2022-08-03)

## [1.1.1](https://github.com/okp4/ontology/compare/v1.1.0...v1.1.1) (2022-07-27)

# [1.1.0](https://github.com/okp4/ontology/compare/v1.0.0...v1.1.0) (2022-02-18)


### Bug Fixes

* fix some typos on comments (after review) ([78d9002](https://github.com/okp4/ontology/commit/78d9002ee9d03074f28673fe074a0bf72a08d604))
* remove subPropertyOf axiom (was erroneous) ([ece3f13](https://github.com/okp4/ontology/commit/ece3f13f842fbb263532c039be2b27ce2b081fda))


### Features

* align labels with property names ([a4fb8ae](https://github.com/okp4/ontology/commit/a4fb8ae48ac156514e7a0efc9fd896099faa9a22))
* fix typo ([600eed6](https://github.com/okp4/ontology/commit/600eed63dc9da6bf81ac4837e17c1e216dc6a80b))
* improve description of ontology ([e4e5dfd](https://github.com/okp4/ontology/commit/e4e5dfd36ade7400447f920f284b3cef90f95fff))
* improve wording of propery ([627dab2](https://github.com/okp4/ontology/commit/627dab2b7d24d70ca4bb076943c0bf4609faf129))
* improve wording of propery ([4343e6b](https://github.com/okp4/ontology/commit/4343e6be61a1ae76ee7f4a3ade480d193833867a))
* introduce Dataset concept ([d575c19](https://github.com/okp4/ontology/commit/d575c199d815c3105a7d9d4ba42ad88660c0eb23))
* introduce Dataspace concept ([f39172e](https://github.com/okp4/ontology/commit/f39172eecca33653fb1595eee7e8eb5be84449f0))
* specify the current status of the ontology ([f9f0dfe](https://github.com/okp4/ontology/commit/f9f0dfe408461f832d867d8f9038000e6c469afb))

# 1.0.0 (2021-10-18)


### Bug Fixes

* fix incorrect version IRI ([c2300e5](https://github.com/okp4/ontology/commit/c2300e5325fd27212baae4e8bba008eedbf39541))


### Features

* add creation date property ([b6093f5](https://github.com/okp4/ontology/commit/b6093f50bdfac4a6839c38001ad673174ce788e4))
* add minimal ontology spec ([ada410a](https://github.com/okp4/ontology/commit/ada410a47dae278233f87719c50eafa911b98e6e))
* add ontology version ([37e696d](https://github.com/okp4/ontology/commit/37e696da033bd8b2ab8feafbdd6c2ff4ff6c1d07))
* add publisher annotation ([4758c97](https://github.com/okp4/ontology/commit/4758c972d17780e0f89e0b5459c126b8ada90be7))
* specify preferred NS prefix & uri ([cfd3691](https://github.com/okp4/ontology/commit/cfd3691c4d5ade727f9a24e856c0bf4f0cda3151))
