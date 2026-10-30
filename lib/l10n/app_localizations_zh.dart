// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '试衣间';

  @override
  String get appName => '试衣间';

  @override
  String get brandLabel => 'ANYWEAR';

  @override
  String get introTitle => '把未来，穿在身上。';

  @override
  String get introSubtitle => 'AI 实时映射你的穿搭灵感。';

  @override
  String get statusReady => '准备就绪';

  @override
  String get statusConnecting => '正在连接';

  @override
  String get statusPreparing => '正在准备画面';

  @override
  String get statusLive => '实时试衣中';

  @override
  String get statusReconnecting => '正在重新连接';

  @override
  String get emptyVideoTitle => '你的下一套穿搭';

  @override
  String get emptyVideoSubtitle => '开始试衣后，画面会在这里出现';

  @override
  String get styleHeading => '选择你的风格';

  @override
  String get uploadGarment => '上传服装';

  @override
  String get openingGallery => '正在打开';

  @override
  String get promptLabel => '穿搭描述';

  @override
  String get promptHint => '支持简体中文，例如：换成浅灰色宽松卫衣，保留白色抽绳。';

  @override
  String get promptExample => '可以描述服装的颜色、材质和版型';

  @override
  String get editPromptTitle => '调整穿搭描述';

  @override
  String get apply => '应用';

  @override
  String get cancel => '取消';

  @override
  String get myGarment => '我的服装';

  @override
  String get startTryOn => '开始试衣';

  @override
  String get stopTryOn => '停止试衣';

  @override
  String get cloudFooter => '云端实时生成 · 切到后台自动暂停';

  @override
  String get consentTitle => '开启实时试衣';

  @override
  String get consentBody =>
      '相机视频和选择的服装图片会发送至 Decart 云端生成试穿效果。请保持网络连接；停止试衣或切到后台会断开连接。';

  @override
  String get decline => '暂不开启';

  @override
  String get agreeAndStart => '同意并开始';

  @override
  String get cannotReadImage => '无法读取图片，请重新选择或检查相册权限。';

  @override
  String get backToFittingRoom => '返回试衣间';

  @override
  String get keySettings => 'AI Key 设置';

  @override
  String get usageInfo => '使用说明';

  @override
  String get usageTitle => '让穿搭先见面';

  @override
  String get usageBody => '选择预设或上传服装图片，点击开始试衣并允许相机访问。保持上半身完整入镜，均匀光线会带来更稳定的效果。';

  @override
  String get gotIt => '知道了';

  @override
  String get fullscreen => '全屏查看';

  @override
  String get exitFullscreen => '退出全屏';

  @override
  String get viewTryOn => '查看试衣';

  @override
  String get viewCamera => '查看原相机';

  @override
  String get switchCamera => '切换摄像头';

  @override
  String get networkUnstable => '网络不稳定，画面可能延迟';

  @override
  String get openSettings => '打开设置';

  @override
  String get keyConfigured => '当前已配置 Key';

  @override
  String get keyNotConfigured => '尚未配置 Key';

  @override
  String get keyStorageBody => '新 Key 加密保存在此设备。保存后会停止当前试衣，下次开始时生效。';

  @override
  String get readingConfiguration => '正在读取配置…';

  @override
  String get keyStorageReadFailed => '无法读取已保存的 Key，请重新保存。';

  @override
  String get apiKeyLabel => 'Decart API Key';

  @override
  String get showKey => '显示输入的 Key';

  @override
  String get hideKey => '隐藏输入的 Key';

  @override
  String get clearKey => '清除当前 Key';

  @override
  String get saveKey => '保存 Key';

  @override
  String get savingKey => '正在保存…';

  @override
  String get enterNewKey => '请输入新的 Decart API Key。';

  @override
  String get invalidKey => '请输入以 dct_ 开头的完整 Decart API Key。';

  @override
  String get releaseBackendOnly => '发布版本需要使用服务端试衣凭据。';

  @override
  String get keySaved => 'AI Key 已保存，点击「开始试衣」使用新 Key。';

  @override
  String get keyCleared => 'AI Key 已清除，请在设置中添加后再开始试衣。';

  @override
  String get disconnectBeforeKey => '试衣尚未断开，请停止后再更换 Key。';

  @override
  String get permissionRequired => '需要相机权限才能试衣，请在系统设置中允许访问相机。';

  @override
  String get pausedMessage => '试衣已暂停，点击「开始试衣」继续。';

  @override
  String get connectionTimeout => '连接试衣服务超时，请稍后重试。';

  @override
  String get networkFailure => '网络连接失败，请检查网络后重试。';

  @override
  String get cameraUnavailable => '相机暂不可用，请使用真机并关闭其他相机应用。';

  @override
  String get invalidApiKey => '试衣服务授权失败，请检查账户和额度。';

  @override
  String get tryOnConnectionError => '试衣连接遇到问题，请停止后重试。';

  @override
  String get operationFailed => '操作未完成，请稍后重试。';

  @override
  String get backendConfigConflict => '开发配置有冲突，请仅选择一种连接方式。';

  @override
  String get releaseConfigError => '发布版本需要接入服务端登录和临时凭据接口。';

  @override
  String get invalidDevelopmentCredential => '开发凭据格式不正确。';

  @override
  String get serviceNotConfigured => '试衣服务暂未配置，请联系应用开发者。';

  @override
  String get noDevelopmentKey => '请先在顶部的「AI Key 设置」中添加 Key。';

  @override
  String get saveKeyFailed => '无法保存 Key，请稍后重试。';

  @override
  String get presetNavyHoodie => '将上衣换成海军蓝纯棉连帽卫衣，白色抽绳，宽松版型。';

  @override
  String get presetWhiteShirt => '将上衣换成干净挺括的白色纯棉牛津衬衫，纽扣领设计。';

  @override
  String get presetLeatherJacket => '将上衣换成黑色机车皮夹克，搭配银色金属拉链。';

  @override
  String get presetDenimJacket => '将上衣换成浅蓝色牛仔外套，宽松休闲版型。';

  @override
  String get presetNavyName => '海军蓝卫衣';

  @override
  String get presetWhiteName => '经典白衬衫';

  @override
  String get presetLeatherName => '黑色皮夹克';

  @override
  String get presetDenimName => '浅蓝牛仔外套';

  @override
  String get referencePrompt => '将当前服装换成参考图片中的衣服，保留服装的颜色、材质和款式细节。';

  @override
  String get qualityWarning => '网络不稳定，画面可能延迟';

  @override
  String get keyFormatError => '请输入以 dct_ 开头的完整 Decart API Key。';

  @override
  String get imageTooLarge => '请选择小于 5 MB 的服装图片。';

  @override
  String get tokenEndpointInvalid => '试衣服务地址配置不正确。';

  @override
  String get loginExpired => '登录已过期，请重新登录后再试。';

  @override
  String get serviceBusy => '当前试衣人数较多，请稍后再试。';

  @override
  String get serviceUnavailable => '试衣服务暂时不可用，请稍后重试。';

  @override
  String get invalidResponse => '试衣服务返回了无效数据。';

  @override
  String get credentialExpired => '试衣凭据无效或已过期，请重试。';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => '試衣間';

  @override
  String get appName => '試衣間';

  @override
  String get brandLabel => 'ANYWEAR';

  @override
  String get introTitle => '把未來，穿在身上。';

  @override
  String get introSubtitle => 'AI 即時映射你的穿搭靈感。';

  @override
  String get statusReady => '準備就緒';

  @override
  String get statusConnecting => '正在連線';

  @override
  String get statusPreparing => '正在準備畫面';

  @override
  String get statusLive => '即時試衣中';

  @override
  String get statusReconnecting => '正在重新連線';

  @override
  String get emptyVideoTitle => '你的下一套穿搭';

  @override
  String get emptyVideoSubtitle => '開始試衣後，畫面會在這裡出現';

  @override
  String get styleHeading => '選擇你的風格';

  @override
  String get uploadGarment => '上傳服裝';

  @override
  String get openingGallery => '正在開啟';

  @override
  String get promptLabel => '穿搭描述';

  @override
  String get promptHint => '支援繁體中文，例如：換成淺灰色寬鬆帽T，保留白色抽繩。';

  @override
  String get promptExample => '可以描述服裝的顏色、材質和版型';

  @override
  String get editPromptTitle => '調整穿搭描述';

  @override
  String get apply => '套用';

  @override
  String get cancel => '取消';

  @override
  String get myGarment => '我的服裝';

  @override
  String get startTryOn => '開始試衣';

  @override
  String get stopTryOn => '停止試衣';

  @override
  String get cloudFooter => '雲端即時生成 · 切換到背景會自動暫停';

  @override
  String get consentTitle => '開啟即時試衣';

  @override
  String get consentBody =>
      '相機影片和選擇的服裝圖片會傳送至 Decart 雲端生成試穿效果。請保持網路連線；停止試衣或切換到背景會中斷連線。';

  @override
  String get decline => '暫不開啟';

  @override
  String get agreeAndStart => '同意並開始';

  @override
  String get cannotReadImage => '無法讀取圖片，請重新選擇或檢查相簿權限。';

  @override
  String get backToFittingRoom => '返回試衣間';

  @override
  String get keySettings => 'AI Key 設定';

  @override
  String get usageInfo => '使用說明';

  @override
  String get usageTitle => '讓穿搭先見面';

  @override
  String get usageBody => '選擇預設或上傳服裝圖片，點擊開始試衣並允許相機存取。保持上半身完整入鏡，均勻光線會帶來更穩定的效果。';

  @override
  String get gotIt => '知道了';

  @override
  String get fullscreen => '全螢幕檢視';

  @override
  String get exitFullscreen => '退出全螢幕';

  @override
  String get viewTryOn => '檢視試衣';

  @override
  String get viewCamera => '檢視原相機';

  @override
  String get switchCamera => '切換鏡頭';

  @override
  String get networkUnstable => '網路不穩定，畫面可能延遲';

  @override
  String get openSettings => '開啟設定';

  @override
  String get keyConfigured => '目前已設定 Key';

  @override
  String get keyNotConfigured => '尚未設定 Key';

  @override
  String get keyStorageBody => '新的 Key 會加密儲存在此裝置。儲存後會停止目前的試衣，下次開始時生效。';

  @override
  String get readingConfiguration => '正在讀取設定…';

  @override
  String get keyStorageReadFailed => '無法讀取已儲存的 Key，請重新儲存。';

  @override
  String get apiKeyLabel => 'Decart API Key';

  @override
  String get showKey => '顯示輸入的 Key';

  @override
  String get hideKey => '隱藏輸入的 Key';

  @override
  String get clearKey => '清除目前 Key';

  @override
  String get saveKey => '儲存 Key';

  @override
  String get savingKey => '正在儲存…';

  @override
  String get enterNewKey => '請輸入新的 Decart API Key。';

  @override
  String get invalidKey => '請輸入以 dct_ 開頭的完整 Decart API Key。';

  @override
  String get releaseBackendOnly => '發布版本需要使用伺服器端試衣憑據。';

  @override
  String get keySaved => 'AI Key 已儲存，點擊「開始試衣」使用新的 Key。';

  @override
  String get keyCleared => 'AI Key 已清除，請在設定中新增後再開始試衣。';

  @override
  String get disconnectBeforeKey => '試衣尚未中斷，請停止後再更換 Key。';

  @override
  String get permissionRequired => '需要相機權限才能試衣，請在系統設定中允許存取相機。';

  @override
  String get pausedMessage => '試衣已暫停，點擊「開始試衣」繼續。';

  @override
  String get connectionTimeout => '連線試衣服務逾時，請稍後再試。';

  @override
  String get networkFailure => '網路連線失敗，請檢查網路後再試。';

  @override
  String get cameraUnavailable => '相機暫時無法使用，請使用實體裝置並關閉其他相機 App。';

  @override
  String get invalidApiKey => '試衣服務授權失敗，請檢查帳戶和額度。';

  @override
  String get tryOnConnectionError => '試衣連線遇到問題，請停止後再試。';

  @override
  String get operationFailed => '操作未完成，請稍後再試。';

  @override
  String get backendConfigConflict => '開發設定有衝突，請只選擇一種連線方式。';

  @override
  String get releaseConfigError => '發布版本需要接入伺服器登入和臨時憑據介面。';

  @override
  String get invalidDevelopmentCredential => '開發憑據格式不正確。';

  @override
  String get serviceNotConfigured => '試衣服務尚未設定，請聯絡應用程式開發者。';

  @override
  String get noDevelopmentKey => '請先在頂部的「AI Key 設定」中新增 Key。';

  @override
  String get saveKeyFailed => '無法儲存 Key，請稍後再試。';

  @override
  String get presetNavyHoodie => '將上衣換成海軍藍純棉連帽上衣，白色抽繩，寬鬆版型。';

  @override
  String get presetWhiteShirt => '將上衣換成乾淨挺括的白色純棉牛津襯衫，釦領設計。';

  @override
  String get presetLeatherJacket => '將上衣換成黑色機車皮夾克，搭配銀色金屬拉鍊。';

  @override
  String get presetDenimJacket => '將上衣換成淺藍色牛仔外套，寬鬆休閒版型。';

  @override
  String get presetNavyName => '海軍藍帽T';

  @override
  String get presetWhiteName => '經典白襯衫';

  @override
  String get presetLeatherName => '黑色皮夾克';

  @override
  String get presetDenimName => '淺藍牛仔外套';

  @override
  String get referencePrompt => '將目前服裝換成參考圖片中的衣服，保留服裝的顏色、材質和款式細節。';

  @override
  String get qualityWarning => '網路不穩定，畫面可能延遲';

  @override
  String get keyFormatError => '請輸入以 dct_ 開頭的完整 Decart API Key。';

  @override
  String get imageTooLarge => '請選擇小於 5 MB 的服裝圖片。';

  @override
  String get tokenEndpointInvalid => '試衣服務地址設定不正確。';

  @override
  String get loginExpired => '登入已過期，請重新登入後再試。';

  @override
  String get serviceBusy => '目前試衣人數較多，請稍後再試。';

  @override
  String get serviceUnavailable => '試衣服務暫時無法使用，請稍後再試。';

  @override
  String get invalidResponse => '試衣服務回傳了無效資料。';

  @override
  String get credentialExpired => '試衣憑據無效或已過期，請重試。';
}
