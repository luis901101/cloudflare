import 'package:cloudflare/cloudflare.dart';
import 'package:cloudflare/src/base_api/rest_api_service.dart';
import 'package:cloudflare/src/service/live_input_service.dart';
import 'package:cloudflare/src/utils/params.dart';

class LiveInputAPI
    extends
        RestAPIService<
          LiveInputService,
          CloudflareLiveInput,
          CloudflareErrorResponse
        > {
  LiveInputAPI({required super.restAPI, required super.accountId})
    : super(
        service: LiveInputService(dio: restAPI.dio, accountId: accountId),
        dataType: CloudflareLiveInput(),
      );

  /// Creates a live input that can be streamed to. Add an output in order to
  /// direct traffic.
  ///
  /// Documentation: https://api.cloudflare.com/#stream-live-inputs-create-a-live-input
  Future<CloudflareHTTPResponse<CloudflareLiveInput?>> create({
    /// Only [meta] and [recording] properties will be taken into account when
    /// creating a live input.
    CloudflareLiveInput? data,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    return parseResponse(service.create(data: data));
  }

  /// View the live inputs that have been created on this account. Some
  /// information is not included on list requests, such as the URL to stream
  /// to. To get that information, request a single live input.
  ///
  /// Documentation: https://api.cloudflare.com/#stream-live-inputs-list-live-inputs
  Future<CloudflareHTTPResponse<List<CloudflareLiveInput>?>> getAll() async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    final response = await parseResponseAsList(service.getAll());
    return response;
  }

  /// Fetch details about a single live input
  /// Documentation: https://api.cloudflare.com/#stream-live-inputs-live-input-details
  Future<CloudflareHTTPResponse<CloudflareLiveInput?>> get({
    /// CloudflareLiveInput identifier
    String? id,

    /// CloudflareLiveInput with the required identifier
    CloudflareLiveInput? liveInput,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
      id != null || liveInput != null,
      'One of id or liveInput must not be empty.',
    );
    id ??= liveInput?.id;
    final response = await parseResponse(service.get(id: id!));
    return response;
  }

  /// Get the [CloudflareStreamVideo] list associated to a [CloudflareLiveInput]
  ///
  /// Documentation: https://developers.cloudflare.com/stream/stream-live/watch-live-stream/
  Future<CloudflareHTTPResponse<List<CloudflareStreamVideo>?>> getVideos({
    /// CloudflareLiveInput identifier
    String? id,

    /// CloudflareLiveInput with the required identifier
    CloudflareLiveInput? liveInput,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
      id != null || liveInput != null,
      'One of id or liveInput must not be null.',
    );
    id ??= liveInput?.id;
    return genericParseResponseAsList(
      service.getVideos(id: id!),
      dataType: CloudflareStreamVideo(),
    );
  }

  /// Update details about a single live input
  ///
  /// Documentation: https://api.cloudflare.com/#stream-live-inputs-update-live-input-details
  Future<CloudflareHTTPResponse<CloudflareLiveInput?>> update({
    /// Only [id], [meta] and [recording] properties will be taken into account
    /// when updating a live input.
    required CloudflareLiveInput liveInput,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    final response = await parseResponse(
      service.update(id: liveInput.id, data: liveInput),
    );
    return response;
  }

  /// Prevent a live input from being streamed to. This makes the live input
  /// inaccessible to any future API calls or RTMPS transmission.
  ///
  /// Documentation: https://api.cloudflare.com/#stream-live-inputs-delete-live-input
  Future<CloudflareHTTPResponse> delete({
    /// CloudflareLiveInput identifier
    String? id,

    /// CloudflareLiveInput with the required identifier
    CloudflareLiveInput? liveInput,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
      id != null || liveInput != null,
      'One of id or liveInput must not be null.',
    );
    id ??= liveInput?.id;
    final response = await getSaveResponse(
      service.delete(id: id!),
      parseCloudflareResponse: false,
    );
    return response;
  }

  /// Deletes a list of live inputs on Cloudflare LiveInput. On success, all
  /// copies of the live inputs are deleted.
  Future<List<CloudflareHTTPResponse>> deleteMultiple({
    /// List of CloudflareLiveInput identifiers
    List<String>? ids,

    /// List of CloudflareLiveInput with their related ids
    List<CloudflareLiveInput>? liveInputs,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
      (ids?.isNotEmpty ?? false) || (liveInputs?.isNotEmpty ?? false),
      'One of ids or live inputs must not be empty.',
    );

    ids ??= liveInputs?.map((liveInput) => liveInput.id).toList();

    List<CloudflareHTTPResponse> responses = [];
    for (final id in ids!) {
      final response = await delete(id: id);
      responses.add(response);
    }
    return responses;
  }

  /// Creates a new output which will be re-streamed to by a live input
  ///
  /// Documentation: https://api.cloudflare.com/#stream-live-inputs-add-an-output-to-a-live-input
  Future<CloudflareHTTPResponse<LiveInputOutput?>> addOutput({
    /// CloudflareLiveInput identifier
    String? liveInputId,

    /// CloudflareLiveInput with the required identifier
    CloudflareLiveInput? liveInput,

    /// Only [url] and [streamKey] properties will be taken into account when
    /// adding an output to a live input.
    required LiveInputOutput data,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
      liveInputId != null || liveInput != null,
      'One of liveInputId or liveInput must not be null.',
    );
    liveInputId ??= liveInput?.id;
    return genericParseResponse(
      service.addOutput(
        liveInputId: liveInputId!,
        data: data.toJson()..removeWhere((key, value) => key == Params.id),
      ),
      dataType: LiveInputOutput(),
    );
  }

  /// List outputs associated with a live input
  ///
  /// Documentation: https://api.cloudflare.com/#stream-live-inputs-list-outputs-associated-with-a-live-input
  Future<CloudflareHTTPResponse<List<LiveInputOutput>?>> getOutputs({
    /// CloudflareLiveInput identifier
    String? liveInputId,

    /// CloudflareLiveInput with the required identifier
    CloudflareLiveInput? liveInput,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
      liveInputId != null || liveInput != null,
      'One of liveInputId or liveInput must not be null.',
    );
    liveInputId ??= liveInput?.id;
    return genericParseResponseAsList(
      service.getOutputs(liveInputId: liveInputId!),
      dataType: LiveInputOutput(),
    );
  }

  /// Removes an output from a live input
  ///
  /// Documentation: https://api.cloudflare.com/#stream-live-inputs-remove-an-output-from-a-live-input
  Future<CloudflareHTTPResponse> removeOutput({
    /// CloudflareLiveInput identifier
    String? liveInputId,

    /// CloudflareLiveInput with the required identifier
    CloudflareLiveInput? liveInput,

    /// LiveInputOutput identifier
    String? outputId,

    /// LiveInputOutput with the required identifier
    LiveInputOutput? output,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
      liveInputId != null || liveInput != null,
      'One of liveInputId or liveInput must not be null.',
    );
    assert(
      outputId != null || output != null,
      'One of outputId or output must not be null.',
    );
    liveInputId ??= liveInput?.id;
    outputId ??= output?.id;
    final response = await getSaveResponse(
      service.removeOutput(liveInputId: liveInputId!, outputId: outputId!),
      parseCloudflareResponse: false,
    );
    return response;
  }

  /// Removes a list of outputs associated to a LiveInput
  Future<List<CloudflareHTTPResponse>> removeMultipleOutputs({
    /// CloudflareLiveInput identifier
    String? liveInputId,

    /// CloudflareLiveInput with the required identifier
    CloudflareLiveInput? liveInput,

    /// List of LiveInputOutput identifiers
    List<String>? outputIds,

    /// List of LiveInputOutput with their related ids
    List<LiveInputOutput>? outputs,
  }) async {
    assert(!isBasic, RestAPIService.authorizedRequestAssertMessage);
    assert(
      liveInputId != null || liveInput != null,
      'One of liveInputId or liveInput must not be null.',
    );
    assert(
      (outputIds?.isNotEmpty ?? false) || (outputs?.isNotEmpty ?? false),
      'One of outputIds or outputs must not be empty.',
    );

    liveInputId ??= liveInput?.id;
    outputIds ??= outputs?.map((output) => output.id).toList();

    List<CloudflareHTTPResponse> responses = [];
    for (final outputId in outputIds!) {
      final response = await removeOutput(
        liveInputId: liveInputId,
        outputId: outputId,
      );
      responses.add(response);
    }
    return responses;
  }
}
