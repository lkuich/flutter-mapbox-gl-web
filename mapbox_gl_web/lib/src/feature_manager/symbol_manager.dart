part of mapbox_gl_web;

/// Signature for when a tap has occurred.
typedef SymbolTapCallback = void Function(String id);

class SymbolManager extends FeatureManager<SymbolOptions> {
  final MapboxMap map;
  final SymbolTapCallback onTap;

  SymbolManager({
    @required this.map,
    this.onTap,
  }) : super(
          sourceId: 'symbol_source',
          layerId: 'symbol_layer',
          map: map,
          onTap: onTap,
        );

  @override
  void initLayer() {
    map.addLayer({
      'id': layerId,
      'type': 'symbol',
      'source': sourceId,
      'layout': {
        'icon-image': '{iconImage}',
        'icon-size': ['get', 'iconSize'],
        'icon-rotate': ['get', 'iconRotate'],
        'icon-offset': ['get', 'iconOffset'],
        'icon-anchor': ['get', 'iconAnchor'],
        'text-field': ['get', 'textField'],
        'text-size': ['get', 'textSize'],
        'text-max-width': ['get', 'textMaxWidth'],
        'text-letter-spacing': ['get', 'textLetterSpacing'],
        'text-justify': ['get', 'textJustify'],
        'text-anchor': ['get', 'textAnchor'],
        'text-rotate': ['get', 'textRotate'],
        'text-transform': ['get', 'textTransform'],
        'text-offset': ['get', 'textOffset'],
        'symbol-sort-key': ['get', 'symbolSortKey'],
        'icon-allow-overlap': true,
        'icon-ignore-placement': true,
        'text-allow-overlap': true,
        'text-ignore-placement': true,
      },
      'paint': {
        'icon-opacity': ['get', 'iconOpacity'],
        'icon-color': ['get', 'iconColor'],
        'icon-halo-color': ['get', 'iconHaloColor'],
        'icon-halo-width': ['get', 'iconHaloWidth'],
        'icon-halo-blur': ['get', 'iconHaloBlur'],
        'text-opacity': ['get', 'textOpacity'],
        'text-color': ['get', 'textColor'],
        'text-halo-color': ['get', 'textHaloColor'],
        'text-halo-width': ['get', 'textHaloWidth'],
        'text-halo-blur': ['get', 'textHaloBlur'],
      }
    });

    map.on('styleimagemissing', (event) {
      if (event.id == '') {
        return;
      }
      int density = (context['window'].devicePixelRatio as double).round();
      if (density > 3) density = 3;
      var imagePath = '/assets/assets/symbols/$density.0x/${event.id}';
      print(imagePath);
      map.loadImage(imagePath, (error, image) {
        if (error != null) throw error;
        if (!map.hasImage(event.id))
          map.addImage(event.id, image, {'pixelRatio': density});
      });
    });
  }

  @override
  void update(String lineId, SymbolOptions changes) {
    Feature olfFeature = getFeature(lineId);
    Feature newFeature = Convert.interpretSymbolOptions(changes, olfFeature);
    updateFeature(newFeature);
  }

  @override
  void onDrag(String featureId, LatLng latLng) {
    update(featureId, SymbolOptions(geometry: latLng));
  }
}
