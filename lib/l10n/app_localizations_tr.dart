// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'BrightWay';

  @override
  String get startPoint => 'Başlangıç Noktası';

  @override
  String get endPoint => 'Bitiş Noktası';

  @override
  String get calculatePath => 'Yol Hesapla';

  @override
  String get pathFound => 'Yol Bulundu';

  @override
  String get noPathAvailable => 'Yol bulunamadı';

  @override
  String get calculatingPath => 'Yol hesaplanıyor...';

  @override
  String pathSteps(int steps) {
    return 'Yol: $steps adım';
  }

  @override
  String get navigationInstructions => 'Navigasyon Talimatları';

  @override
  String startFacing(String direction) {
    return '$direction yönüne dönerek başlayın';
  }

  @override
  String get turnLeft => 'Sola dönün';

  @override
  String get turnRight => 'Sağa dönün';

  @override
  String get turnAround => 'Geri dönün';

  @override
  String get goStraight => 'Düz gidin';

  @override
  String get takeStep => '1 adım ileri gidin';

  @override
  String takeStepToDestination(String destination) {
    return '$destination konumuna ulaşmak için 1 adım ileri gidin';
  }

  @override
  String youHaveArrived(String destination) {
    return '$destination konumuna ulaştınız';
  }

  @override
  String startingFrom(String start, String direction) {
    return '$start konumundan başlayarak $direction yönüne dönün';
  }

  @override
  String get walkForward => 'Bir adım ileri yürüyün';

  @override
  String walkForwardToDestination(String destination) {
    return '$destination konumuna ulaşmak için bir adım ileri yürüyün';
  }

  @override
  String get directionNorth => 'kuzey';

  @override
  String get directionSouth => 'güney';

  @override
  String get directionLeft => 'sol';

  @override
  String get directionRight => 'sağ';

  @override
  String pathfindingStartingAlgorithm(String start, String end) {
    return 'A* algoritması $start konumundan $end konumuna başlatılıyor';
  }

  @override
  String pathfindingGridSize(int rows, int cols) {
    return 'Izgara boyutu: ${rows}x$cols';
  }

  @override
  String pathfindingPathFound(int iterations) {
    return 'Yol $iterations iterasyonda bulundu';
  }

  @override
  String pathfindingPathCalculated(int steps) {
    return 'Yol hesaplandı: $steps adım';
  }

  @override
  String pathfindingNoPathFound(int iterations) {
    return '$iterations iterasyonda yol bulunamadı';
  }

  @override
  String get gridLegend =>
      'Açıklama: [D] = Yürünebilir (kapılar), [X] = Engel (hareketi engeller), [ ] = Boş alan';

  @override
  String get gridNote =>
      'Not: Tüm öğeler hedef olabilir, ancak sadece kapılar hareket etmeye izin verir';

  @override
  String gridRow(int row) {
    return 'Satır $row';
  }

  @override
  String get itemToilet => 'Tuvalet';

  @override
  String get itemTable => 'Masa';

  @override
  String get itemChair => 'Sandalye';

  @override
  String get itemDoor => 'Kapı';

  @override
  String get itemExitDoor => 'Çıkış Kapısı';

  @override
  String get itemWall => 'Duvar';

  @override
  String get itemObstacle => 'Engel';

  @override
  String errorPathCalculation(String error) {
    return 'Yol hesaplanırken hata: $error';
  }

  @override
  String errorTTSFailed(String error) {
    return 'Metin-konuşma başarısız: $error';
  }

  @override
  String get userWelcome => 'Hoş Geldiniz!';

  @override
  String get userPanel => 'Kullanıcı Paneli';

  @override
  String get places => 'Mekanlar';

  @override
  String get placesSubtitle => 'Mevcut mekanları keşfedin';

  @override
  String get settings => 'Ayarlar';

  @override
  String get settingsSubtitle => 'Uygulama ayarları';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get languageSelection => 'Dil Seçimi';

  @override
  String get languageSection => 'Dil';

  @override
  String get cancel => 'İptal';

  @override
  String get apply => 'Uygula';

  @override
  String get applyChanges => 'Değişiklikleri Uygula';

  @override
  String get languageChangeInfo =>
      'Dil değişiklikleri hem uygulama arayüzünü hem de metin-konuşma özelliğini etkileyecektir. Yeni dil uygulanmak için uygulama yeniden başlatılacaktır.';

  @override
  String get availablePlaces => 'Mevcut Mekanlar';

  @override
  String get discoverAmazingPlaces => 'Harika Mekanları Keşfedin!';

  @override
  String get browseDesignsDescription =>
      'Topluluk yöneticilerimiz tarafından oluşturulan tasarımları keşfedin';

  @override
  String get availableDesigns => 'Mevcut Tasarımlar';

  @override
  String designsCount(int count) {
    return '$count tasarım';
  }

  @override
  String get noDesignsAvailable => 'Tasarım Bulunamadı';

  @override
  String get noDesignsDescription =>
      'Yöneticiler henüz tasarım oluşturmadı.\nDaha sonra tekrar kontrol edin!';

  @override
  String createdBy(String adminName) {
    return 'Oluşturan: $adminName';
  }

  @override
  String itemsCount(int count) {
    return '$count öğe';
  }

  @override
  String createdOn(String date) {
    return 'Oluşturulma: $date';
  }

  @override
  String get selectStartPoint => 'Başlangıç Noktası Seç';

  @override
  String get selectEndPoint => 'Bitiş Noktası Seç';

  @override
  String pathLength(int steps) {
    return 'Yol Uzunluğu: $steps adım';
  }

  @override
  String get noPathFound => 'Seçilen noktalar arasında yol bulunamadı';

  @override
  String get pathCalculationError => 'Yol hesaplanırken hata oluştu';

  @override
  String gridSize(int rows, int cols) {
    return 'Izgara Boyutu: $rows×$cols';
  }

  @override
  String totalItems(int count) {
    return 'Toplam Öğe: $count';
  }

  @override
  String get calculating => 'Hesaplanıyor...';

  @override
  String get go => 'Git!';

  @override
  String selectPoint(String title) {
    return '$title Seç';
  }

  @override
  String positionAt(int row, int col) {
    return 'Konum: ($row, $col)';
  }

  @override
  String get navigationPath => 'Navigasyon Yolu';

  @override
  String totalSteps(int count) {
    return 'Toplam adım: $count';
  }

  @override
  String get stepByStepDirections => 'Adım adım yönergeler:';

  @override
  String get tapSpeakerToHearInstructions =>
      'Navigasyon talimatlarını duymak için hoparlör düğmesine dokunun';

  @override
  String get ttsNotAvailableTapButtonToShowInstructions =>
      'TTS mevcut değil. Talimatları göstermek için aşağıdaki düğmeye dokunun.';

  @override
  String get retryTts => 'TTS\'yi Tekrar Dene';

  @override
  String get speakNavigationInstructions =>
      'Navigasyon Talimatlarını Seslendir';

  @override
  String get showNavigationInstructions => 'Navigasyon Talimatlarını Göster';

  @override
  String get navigation => 'Navigasyon';
}
