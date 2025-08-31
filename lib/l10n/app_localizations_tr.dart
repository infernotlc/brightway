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
  String get endPoint => 'Hedef Nokta';

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
  String get navigationInstructions => 'Yönlendirme Talimatları';

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
  String get help => 'Yardım';

  @override
  String get helpSubtitle => 'Kullanım kılavuzu';

  @override
  String get settings => 'Ayarlar';

  @override
  String get settingsSubtitle => 'Uygulama ayarları';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutSubtitle => 'Uygulama bilgileri';

  @override
  String get helpTitle => 'Yardım';

  @override
  String get helpContent =>
      'Mekanları Keşfetme:\n• Mekanlar bölümüne tıklayarak mevcut tasarımları görüntüleyin\n• Bir mekan seçerek detaylarını inceleyin\n• Navigasyon talimatlarını dinleyin\n\nNavigasyon:\n• Sol, sağ, yukarı, aşağı yönlerini kullanın\n• Metin-konuşma özelliği ile sesli yönlendirme alın';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsContent => 'Ayarlar yakında eklenecek...';

  @override
  String get aboutTitle => 'Hakkında';

  @override
  String get aboutContent =>
      'Görme engelli kullanıcılar için mekan navigasyon uygulaması\n\nÖzellikler:\n• Grid tabanlı mekan tasarımı\n• A* algoritması ile en kısa yol bulma\n• Metin-konuşma ile sesli navigasyon\n• Türkçe dil desteği';

  @override
  String get ok => 'Tamam';
}
