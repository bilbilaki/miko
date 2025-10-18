// // Add these to your pubspec.yaml dependencies:
// // json_annotation: ^4.8.1
// // dev_dependencies:
// //   build_runner: ^2.4.6
// //   json_serializable: ^6.7.1
// // Then run: flutter pub run build_runner build

// import 'package:json_annotation/json_annotation.dart';

// part 'media_item.g.dart';

// // Enums based on sample values (add more if needed from API documentation)
// enum ExtraType {
//   @JsonValue('Unknown')
//   unknown,
// }

// enum Video3DFormat {
//   @JsonValue('HalfSideBySide')
//   halfSideBySide,
// }

// enum Protocol {
//   @JsonValue('File')
//   file,
//   @JsonValue('Http')
//   http,
//   // Add others as needed
// }

// enum MediaSourceType {
//   @JsonValue('Default')
//   defaultType,
// }

// enum IsoType {
//   @JsonValue('Dvd')
//   dvd,
// }

// enum VideoType {
//   @JsonValue('VideoFile')
//   videoFile,
// }

// enum StreamType {
//   @JsonValue('Audio')
//   audio,
//   @JsonValue('Video')
//   video,
//   @JsonValue('Subtitle')
//   subtitle,
// }

// enum VideoRange {
//   @JsonValue('Unknown')
//   unknown,
// }

// enum VideoRangeType {
//   @JsonValue('Unknown')
//   unknown,
// }

// enum AudioSpatialFormat {
//   @JsonValue('None')
//   none,
// }

// enum PlayAccess {
//   @JsonValue('Full')
//   full,
// }

// enum LocationType {
//   @JsonValue('FileSystem')
//   fileSystem,
// }

// enum ImageOrientation {
//   @JsonValue('TopLeft')
//   topLeft,
// }

// enum ChannelType {
//   @JsonValue('TV')
//   tv,
// }

// enum AudioType {
//   @JsonValue('Mono')
//   mono,
// }

// @JsonSerializable()
// class MediaItem {
//   final String Name;
//   final String OriginalTitle;
//   final String ServerId;
//   final String Id;
//   final String Etag;
//   final String SourceType;
//   final String PlaylistItemId;
//   final DateTime? DateCreated;
//   final DateTime? DateLastMediaAdded;
//   final ExtraType ExtraType;
//   final int AirsBeforeSeasonNumber;
//   final int AirsAfterSeasonNumber;
//   final int AirsBeforeEpisodeNumber;
//   final bool CanDelete;
//   final bool CanDownload;
//   final bool HasLyrics;
//   final bool HasSubtitles;
//   final String PreferredMetadataLanguage;
//   final String PreferredMetadataCountryCode;
//   final String Container;
//   final String SortName;
//   final String ForcedSortName;
//   final Video3DFormat Video3DFormat;
//   final DateTime? PremiereDate;
//   final List<ExternalUrl> ExternalUrls;
//   final List<MediaSource> MediaSources;
//   final int CriticRating;
//   final List<String> ProductionLocations;
//   final String Path;
//   final bool EnableMediaSourceDisplay;
//   final String OfficialRating;
//   final String CustomRating;
//   final String ChannelId;
//   final String ChannelName;
//   final String Overview;
//   final List<String> Taglines;
//   final List<String> Genres;
//   final int CommunityRating;
//   final int CumulativeRunTimeTicks;
//   final int RunTimeTicks;
//   final PlayAccess PlayAccess;
//   final String AspectRatio;
//   final int ProductionYear;
//   final bool IsPlaceHolder;
//   final String Number;
//   final String ChannelNumber;
//   final int IndexNumber;
//   final int IndexNumberEnd;
//   final int ParentIndexNumber;
//   final List<RemoteTrailer> RemoteTrailers;
//   final Map<String, String> ProviderIds;
//   final bool IsHD;
//   final bool IsFolder;
//   final String ParentId;
//   final String Type;
//   final List<Person> People;
//   final List<Studio> Studios;
//   final List<GenreItem> GenreItems;
//   final String ParentLogoItemId;
//   final String ParentBackdropItemId;
//   final List<String> ParentBackdropImageTags;
//   final int LocalTrailerCount;
//   final UserData UserData;
//   final int RecursiveItemCount;
//   final int ChildCount;
//   final String SeriesName;
//   final String SeriesId;
//   final String SeasonId;
//   final int SpecialFeatureCount;
//   final String DisplayPreferencesId;
//   final String Status;
//   final String AirTime;
//   final List<String> AirDays;
//   final List<String> Tags;
//   final int PrimaryImageAspectRatio;
//   final List<String> Artists;
//   final List<ArtistItem> ArtistItems;
//   final String Album;
//   final String CollectionType;
//   final String DisplayOrder;
//   final String AlbumId;
//   final String AlbumPrimaryImageTag;
//   final String SeriesPrimaryImageTag;
//   final String AlbumArtist;
//   final List<AlbumArtist> AlbumArtists;
//   final String SeasonName;
//   final List<MediaStream> MediaStreams;
//   final VideoType VideoType;
//   final int PartCount;
//   final int MediaSourceCount;
//   final Map<String, String> ImageTags;
//   final List<String> BackdropImageTags;
//   final List<String> ScreenshotImageTags;
//   final String ParentLogoImageTag;
//   final String ParentArtItemId;
//   final String ParentArtImageTag;
//   final String SeriesThumbImageTag;
//   final ImageBlurHashes ImageBlurHashes;
//   final String SeriesStudio;
//   final String ParentThumbItemId;
//   final String ParentThumbImageTag;
//   final String ParentPrimaryImageItemId;
//   final String ParentPrimaryImageTag;
//   final List<Chapter> Chapters;
//   final Map<String, Map<String, TrickplayInfo>> Trickplay;
//   final LocationType LocationType;
//   final IsoType IsoType;
//   final String MediaType;
//   final DateTime? EndDate;
//   final List<String> LockedFields;
//   final int TrailerCount;
//   final int MovieCount;
//   final int SeriesCount;
//   final int ProgramCount;
//   final int EpisodeCount;
//   final int SongCount;
//   final int AlbumCount;
//   final int ArtistCount;
//   final int MusicVideoCount;
//   final bool LockData;
//   final int Width;
//   final int Height;
//   final String CameraMake;
//   final String CameraModel;
//   final String Software;
//   final int ExposureTime;
//   final int FocalLength;
//   final ImageOrientation ImageOrientation;
//   final int Aperture;
//   final int ShutterSpeed;
//   final int Latitude;
//   final int Longitude;
//   final int Altitude;
//   final int IsoSpeedRating;
//   final String SeriesTimerId;
//   final String ProgramId;
//   final String ChannelPrimaryImageTag;
//   final DateTime? StartDate;
//   final int CompletionPercentage;
//   final bool IsRepeat;
//   final String EpisodeTitle;
//   final ChannelType ChannelType;
//   final AudioType Audio;
//   final bool IsMovie;
//   final bool IsSports;
//   final bool IsSeries;
//   final bool IsLive;
//   final bool IsNews;
//   final bool IsKids;
//   final bool IsPremiere;
//   final String TimerId;
//   final int NormalizationGain;
//   final Map<String, dynamic>? CurrentProgram;

//   MediaItem({
//     required this.Name,
//     required this.OriginalTitle,
//     required this.ServerId,
//     required this.Id,
//     required this.Etag,
//     required this.SourceType,
//     required this.PlaylistItemId,
//     this.DateCreated,
//     this.DateLastMediaAdded,
//     required this.ExtraType,
//     required this.AirsBeforeSeasonNumber,
//     required this.AirsAfterSeasonNumber,
//     required this.AirsBeforeEpisodeNumber,
//     required this.CanDelete,
//     required this.CanDownload,
//     required this.HasLyrics,
//     required this.HasSubtitles,
//     required this.PreferredMetadataLanguage,
//     required this.PreferredMetadataCountryCode,
//     required this.Container,
//     required this.SortName,
//     required this.ForcedSortName,
//     required this.Video3DFormat,
//     this.PremiereDate,
//     required this.ExternalUrls,
//     required this.MediaSources,
//     required this.CriticRating,
//     required this.ProductionLocations,
//     required this.Path,
//     required this.EnableMediaSourceDisplay,
//     required this.OfficialRating,
//     required this.CustomRating,
//     required this.ChannelId,
//     required this.ChannelName,
//     required this.Overview,
//     required this.Taglines,
//     required this.Genres,
//     required this.CommunityRating,
//     required this.CumulativeRunTimeTicks,
//     required this.RunTimeTicks,
//     required this.PlayAccess,
//     required this.AspectRatio,
//     required this.ProductionYear,
//     required this.IsPlaceHolder,
//     required this.Number,
//     required this.ChannelNumber,
//     required this.IndexNumber,
//     required this.IndexNumberEnd,
//     required this.ParentIndexNumber,
//     required this.RemoteTrailers,
//     required this.ProviderIds,
//     required this.IsHD,
//     required this.IsFolder,
//     required this.ParentId,
//     required this.Type,
//     required this.People,
//     required this.Studios,
//     required this.GenreItems,
//     required this.ParentLogoItemId,
//     required this.ParentBackdropItemId,
//     required this.ParentBackdropImageTags,
//     required this.LocalTrailerCount,
//     required this.UserData,
//     required this.RecursiveItemCount,
//     required this.ChildCount,
//     required this.SeriesName,
//     required this.SeriesId,
//     required this.SeasonId,
//     required this.SpecialFeatureCount,
//     required this.DisplayPreferencesId,
//     required this.Status,
//     required this.AirTime,
//     required this.AirDays,
//     required this.Tags,
//     required this.PrimaryImageAspectRatio,
//     required this.Artists,
//     required this.ArtistItems,
//     required this.Album,
//     required this.CollectionType,
//     required this.DisplayOrder,
//     required this.AlbumId,
//     required this.AlbumPrimaryImageTag,
//     required this.SeriesPrimaryImageTag,
//     required this.AlbumArtist,
//     required this.AlbumArtists,
//     required this.SeasonName,
//     required this.MediaStreams,
//     required this.VideoType,
//     required this.PartCount,
//     required this.MediaSourceCount,
//     required this.ImageTags,
//     required this.BackdropImageTags,
//     required this.ScreenshotImageTags,
//     required this.ParentLogoImageTag,
//     required this.ParentArtItemId,
//     required this.ParentArtImageTag,
//     required this.SeriesThumbImageTag,
//     required this.ImageBlurHashes,
//     required this.SeriesStudio,
//     required this.ParentThumbItemId,
//     required this.ParentThumbImageTag,
//     required this.ParentPrimaryImageItemId,
//     required this.ParentPrimaryImageTag,
//     required this.Chapters,
//     required this.Trickplay,
//     required this.LocationType,
//     required this.IsoType,
//     required this.MediaType,
//     this.EndDate,
//     required this.LockedFields,
//     required this.TrailerCount,
//     required this.MovieCount,
//     required this.SeriesCount,
//     required this.ProgramCount,
//     required this.EpisodeCount,
//     required this.SongCount,
//     required this.AlbumCount,
//     required this.ArtistCount,
//     required this.MusicVideoCount,
//     required this.LockData,
//     required this.Width,
//     required this.Height,
//     required this.CameraMake,
//     required this.CameraModel,
//     required this.Software,
//     required this.ExposureTime,
//     required this.FocalLength,
//     required this.ImageOrientation,
//     required this.Aperture,
//     required this.ShutterSpeed,
//     required this.Latitude,
//     required this.Longitude,
//     required this.Altitude,
//     required this.IsoSpeedRating,
//     required this.SeriesTimerId,
//     required this.ProgramId,
//     required this.ChannelPrimaryImageTag,
//     this.StartDate,
//     required this.CompletionPercentage,
//     required this.IsRepeat,
//     required this.EpisodeTitle,
//     required this.ChannelType,
//     required this.Audio,
//     required this.IsMovie,
//     required this.IsSports,
//     required this.IsSeries,
//     required this.IsLive,
//     required this.IsNews,
//     required this.IsKids,
//     required this.IsPremiere,
//     required this.TimerId,
//     required this.NormalizationGain,
//     this.CurrentProgram,
//   });

//   factory MediaItem.fromJson(Map<String, dynamic> json) =>
//       _$MediaItemFromJson(json);
//   Map<String, dynamic> toJson() => _$MediaItemToJson(this);
// }

// @JsonSerializable()
// class ExternalUrl {
//   final String Name;
//   final String Url;

//   ExternalUrl({required this.Name, required this.Url});

//   factory ExternalUrl.fromJson(Map<String, dynamic> json) =>
//       _$ExternalUrlFromJson(json);
//   Map<String, dynamic> toJson() => _$ExternalUrlToJson(this);
// }

// @JsonSerializable()
// class MediaSource {
//   final Protocol Protocol;
//   final String Id;
//   final String Path;
//   final String EncoderPath;
//   final Protocol EncoderProtocol;
//   final MediaSourceType Type;
//   final String Container;
//   final int Size;
//   final String Name;
//   final bool IsRemote;
//   final String ETag;
//   final int RunTimeTicks;
//   final bool ReadAtNativeFramerate;
//   final bool IgnoreDts;
//   final bool IgnoreIndex;
//   final bool GenPtsInput;
//   final bool SupportsTranscoding;
//   final bool SupportsDirectStream;
//   final bool SupportsDirectPlay;
//   final bool IsInfiniteStream;
//   final bool UseMostCompatibleTranscodingProfile;
//   final bool RequiresOpening;
//   final String OpenToken;
//   final bool RequiresClosing;
//   final String LiveStreamId;
//   final int BufferMs;
//   final bool RequiresLooping;
//   final bool SupportsProbing;
//   final VideoType VideoType;
//   final IsoType IsoType;
//   final Video3DFormat Video3DFormat;
//   final List<MediaStream> MediaStreams;
//   final List<MediaAttachment> MediaAttachments;
//   final List<String> Formats;
//   final int Bitrate;
//   final int FallbackMaxStreamingBitrate;
//   final String Timestamp;
//   final Map<String, String> RequiredHttpHeaders;
//   final String TranscodingUrl;
//   final String TranscodingSubProtocol;
//   final String TranscodingContainer;
//   final int AnalyzeDurationMs;
//   final int DefaultAudioStreamIndex;
//   final int DefaultSubtitleStreamIndex;
//   final bool HasSegments;

//   MediaSource({
//     required this.Protocol,
//     required this.Id,
//     required this.Path,
//     required this.EncoderPath,
//     required this.EncoderProtocol,
//     required this.Type,
//     required this.Container,
//     required this.Size,
//     required this.Name,
//     required this.IsRemote,
//     required this.ETag,
//     required this.RunTimeTicks,
//     required this.ReadAtNativeFramerate,
//     required this.IgnoreDts,
//     required this.IgnoreIndex,
//     required this.GenPtsInput,
//     required this.SupportsTranscoding,
//     required this.SupportsDirectStream,
//     required this.SupportsDirectPlay,
//     required this.IsInfiniteStream,
//     required this.UseMostCompatibleTranscodingProfile,
//     required this.RequiresOpening,
//     required this.OpenToken,
//     required this.RequiresClosing,
//     required this.LiveStreamId,
//     required this.BufferMs,
//     required this.RequiresLooping,
//     required this.SupportsProbing,
//     required this.VideoType,
//     required this.IsoType,
//     required this.Video3DFormat,
//     required this.MediaStreams,
//     required this.MediaAttachments,
//     required this.Formats,
//     required this.Bitrate,
//     required this.FallbackMaxStreamingBitrate,
//     required this.Timestamp,
//     required this.RequiredHttpHeaders,
//     required this.TranscodingUrl,
//     required this.TranscodingSubProtocol,
//     required this.TranscodingContainer,
//     required this.AnalyzeDurationMs,
//     required this.DefaultAudioStreamIndex,
//     required this.DefaultSubtitleStreamIndex,
//     required this.HasSegments,
//   });

//   factory MediaSource.fromJson(Map<String, dynamic> json) =>
//       _$MediaSourceFromJson(json);
//   Map<String, dynamic> toJson() => _$MediaSourceToJson(this);
// }

// @JsonSerializable()
// class MediaStream {
//   final String Codec;
//   final String CodecTag;
//   final String Language;
//   final String ColorRange;
//   final String ColorSpace;
//   final String ColorTransfer;
//   final String ColorPrimaries;
//   final int DvVersionMajor;
//   final int DvVersionMinor;
//   final int DvProfile;
//   final int DvLevel;
//   final int RpuPresentFlag;
//   final int ElPresentFlag;
//   final int BlPresentFlag;
//   final int DvBlSignalCompatibilityId;
//   final int Rotation;
//   final String Comment;
//   final String TimeBase;
//   final String CodecTimeBase;
//   final String Title;
//   final bool Hdr10PlusPresentFlag;
//   final VideoRange VideoRange;
//   final VideoRangeType VideoRangeType;
//   final String VideoDoViTitle;
//   final AudioSpatialFormat AudioSpatialFormat;
//   final String LocalizedUndefined;
//   final String LocalizedDefault;
//   final String LocalizedForced;
//   final String LocalizedExternal;
//   final String LocalizedHearingImpaired;
//   final String DisplayTitle;
//   final String NalLengthSize;
//   final bool IsInterlaced;
//   final bool IsAVC;
//   final String ChannelLayout;
//   final int BitRate;
//   final int BitDepth;
//   final int RefFrames;
//   final int PacketLength;
//   final int Channels;
//   final int SampleRate;
//   final bool IsDefault;
//   final bool IsForced;
//   final bool IsHearingImpaired;
//   final int Height;
//   final int Width;
//   final int AverageFrameRate;
//   final int RealFrameRate;
//   final int ReferenceFrameRate;
//   final String Profile;
//   final StreamType Type;
//   final String AspectRatio;
//   final int Index;
//   final int Score;
//   final bool IsExternal;
//   final String DeliveryMethod;
//   final String DeliveryUrl;
//   final bool IsExternalUrl;
//   final bool IsTextSubtitleStream;
//   final bool SupportsExternalStream;
//   final String Path;
//   final String PixelFormat;
//   final int Level;
//   final bool IsAnamorphic;

//   MediaStream({
//     required this.Codec,
//     required this.CodecTag,
//     required this.Language,
//     required this.ColorRange,
//     required this.ColorSpace,
//     required this.ColorTransfer,
//     required this.ColorPrimaries,
//     required this.DvVersionMajor,
//     required this.DvVersionMinor,
//     required this.DvProfile,
//     required this.DvLevel,
//     required this.RpuPresentFlag,
//     required this.ElPresentFlag,
//     required this.BlPresentFlag,
//     required this.DvBlSignalCompatibilityId,
//     required this.Rotation,
//     required this.Comment,
//     required this.TimeBase,
//     required this.CodecTimeBase,
//     required this.Title,
//     required this.Hdr10PlusPresentFlag,
//     required this.VideoRange,
//     required this.VideoRangeType,
//     required this.VideoDoViTitle,
//     required this.AudioSpatialFormat,
//     required this.LocalizedUndefined,
//     required this.LocalizedDefault,
//     required this.LocalizedForced,
//     required this.LocalizedExternal,
//     required this.LocalizedHearingImpaired,
//     required this.DisplayTitle,
//     required this.NalLengthSize,
//     required this.IsInterlaced,
//     required this.IsAVC,
//     required this.ChannelLayout,
//     required this.BitRate,
//     required this.BitDepth,
//     required this.RefFrames,
//     required this.PacketLength,
//     required this.Channels,
//     required this.SampleRate,
//     required this.IsDefault,
//     required this.IsForced,
//     required this.IsHearingImpaired,
//     required this.Height,
//     required this.Width,
//     required this.AverageFrameRate,
//     required this.RealFrameRate,
//     required this.ReferenceFrameRate,
//     required this.Profile,
//     required this.Type,
//     required this.AspectRatio,
//     required this.Index,
//     required this.Score,
//     required this.IsExternal,
//     required this.DeliveryMethod,
//     required this.DeliveryUrl,
//     required this.IsExternalUrl,
//     required this.IsTextSubtitleStream,
//     required this.SupportsExternalStream,
//     required this.Path,
//     required this.PixelFormat,
//     required this.Level,
//     required this.IsAnamorphic,
//   });

//   factory MediaStream.fromJson(Map<String, dynamic> json) =>
//       _$MediaStreamFromJson(json);
//   Map<String, dynamic> toJson() => _$MediaStreamToJson(this);
// }

// @JsonSerializable()
// class MediaAttachment {
//   final String Codec;
//   final String CodecTag;
//   final String Comment;
//   final int Index;
//   final String FileName;
//   final String MimeType;
//   final String DeliveryUrl;

//   MediaAttachment({
//     required this.Codec,
//     required this.CodecTag,
//     required this.Comment,
//     required this.Index,
//     required this.FileName,
//     required this.MimeType,
//     required this.DeliveryUrl,
//   });

//   factory MediaAttachment.fromJson(Map<String, dynamic> json) =>
//       _$MediaAttachmentFromJson(json);
//   Map<String, dynamic> toJson() => _$MediaAttachmentToJson(this);
// }

// @JsonSerializable()
// class RemoteTrailer {
//   final String Url;
//   final String Name;

//   RemoteTrailer({required this.Url, required this.Name});

//   factory RemoteTrailer.fromJson(Map<String, dynamic> json) =>
//       _$RemoteTrailerFromJson(json);
//   Map<String, dynamic> toJson() => _$RemoteTrailerToJson(this);
// }

// @JsonSerializable()
// class Person {
//   final String Name;
//   final String Id;
//   final String Role;
//   final String Type;
//   final String PrimaryImageTag;
//   final ImageBlurHashes ImageBlurHashes;

//   Person({
//     required this.Name,
//     required this.Id,
//     required this.Role,
//     required this.Type,
//     required this.PrimaryImageTag,
//     required this.ImageBlurHashes,
//   });

//   factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
//   Map<String, dynamic> toJson() => _$PersonToJson(this);
// }

// @JsonSerializable()
// class Studio {
//   final String Name;
//   final String Id;

//   Studio({required this.Name, required this.Id});

//   factory Studio.fromJson(Map<String, dynamic> json) => _$StudioFromJson(json);
//   Map<String, dynamic> toJson() => _$StudioToJson(this);
// }

// @JsonSerializable()
// class GenreItem {
//   final String Name;
//   final String Id;

//   GenreItem({required this.Name, required this.Id});

//   factory GenreItem.fromJson(Map<String, dynamic> json) =>
//       _$GenreItemFromJson(json);
//   Map<String, dynamic> toJson() => _$GenreItemToJson(this);
// }

// @JsonSerializable()
// class ArtistItem {
//   final String Name;
//   final String Id;

//   ArtistItem({required this.Name, required this.Id});

//   factory ArtistItem.fromJson(Map<String, dynamic> json) =>
//       _$ArtistItemFromJson(json);
//   Map<String, dynamic> toJson() => _$ArtistItemToJson(this);
// }

// @JsonSerializable()
// class AlbumArtist {
//   final String Name;
//   final String Id;

//   AlbumArtist({required this.Name, required this.Id});

//   factory AlbumArtist.fromJson(Map<String, dynamic> json) =>
//       _$AlbumArtistFromJson(json);
//   Map<String, dynamic> toJson() => _$AlbumArtistToJson(this);
// }

// @JsonSerializable()
// class UserData {
//   final int Rating;
//   final int PlayedPercentage;
//   final int UnplayedItemCount;
//   final int PlaybackPositionTicks;
//   final int PlayCount;
//   final bool IsFavorite;
//   final bool Likes;
//   final DateTime? LastPlayedDate;
//   final bool Played;
//   final String Key;
//   final String ItemId;

//   UserData({
//     required this.Rating,
//     required this.PlayedPercentage,
//     required this.UnplayedItemCount,
//     required this.PlaybackPositionTicks,
//     required this.PlayCount,
//     required this.IsFavorite,
//     required this.Likes,
//     this.LastPlayedDate,
//     required this.Played,
//     required this.Key,
//     required this.ItemId,
//   });

//   factory UserData.fromJson(Map<String, dynamic> json) =>
//       _$UserDataFromJson(json);
//   Map<String, dynamic> toJson() => _$UserDataToJson(this);
// }

// @JsonSerializable()
// class ImageBlurHashes {
//   final Map<String, String> Primary;
//   final Map<String, String> Art;
//   final Map<String, String> Backdrop;
//   final Map<String, String> Banner;
//   final Map<String, String> Logo;
//   final Map<String, String> Thumb;
//   final Map<String, String> Disc;
//   final Map<String, String> Box;
//   final Map<String, String> Screenshot;
//   final Map<String, String> Menu;
//   final Map<String, String> Chapter;
//   final Map<String, String> BoxRear;
//   final Map<String, String> Profile;

//   ImageBlurHashes({
//     required this.Primary,
//     required this.Art,
//     required this.Backdrop,
//     required this.Banner,
//     required this.Logo,
//     required this.Thumb,
//     required this.Disc,
//     required this.Box,
//     required this.Screenshot,
//     required this.Menu,
//     required this.Chapter,
//     required this.BoxRear,
//     required this.Profile,
//   });

//   factory ImageBlurHashes.fromJson(Map<String, dynamic> json) =>
//       _$ImageBlurHashesFromJson(json);
//   Map<String, dynamic> toJson() => _$ImageBlurHashesToJson(this);
// }

// @JsonSerializable()
// class Chapter {
//   final int StartPositionTicks;
//   final String Name;
//   final String ImagePath;
//   final DateTime? ImageDateModified;
//   final String ImageTag;

//   Chapter({
//     required this.StartPositionTicks,
//     required this.Name,
//     required this.ImagePath,
//     this.ImageDateModified,
//     required this.ImageTag,
//   });

//   factory Chapter.fromJson(Map<String, dynamic> json) =>
//       _$ChapterFromJson(json);
//   Map<String, dynamic> toJson() => _$ChapterToJson(this);
// }

// @JsonSerializable()
// class TrickplayInfo {
//   final int Width;
//   final int Height;
//   final int TileWidth;
//   final int TileHeight;
//   final int ThumbnailCount;
//   final int Interval;
//   final int Bandwidth;

//   TrickplayInfo({
//     required this.Width,
//     required this.Height,
//     required this.TileWidth,
//     required this.TileHeight,
//     required this.ThumbnailCount,
//     required this.Interval,
//     required this.Bandwidth,
//   });

//   factory TrickplayInfo.fromJson(Map<String, dynamic> json) =>
//       _$TrickplayInfoFromJson(json);
//   Map<String, dynamic> toJson() => _$TrickplayInfoToJson(this);
// }
