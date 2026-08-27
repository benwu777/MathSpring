enum MonetizationConfiguration { notConfigured, configured }

abstract interface class MonetizationService {
  MonetizationConfiguration get configuration;
  bool get hasAdFreeEntitlement;
  bool get shouldShowBanner;
}

class NoopMonetizationService implements MonetizationService {
  const NoopMonetizationService();

  @override
  MonetizationConfiguration get configuration =>
      MonetizationConfiguration.notConfigured;

  @override
  bool get hasAdFreeEntitlement => false;

  @override
  bool get shouldShowBanner => false;
}
