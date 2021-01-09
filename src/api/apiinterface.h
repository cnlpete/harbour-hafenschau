#ifndef APIINTERFACE_H
#define APIINTERFACE_H

#include <QObject>

static const QString HAFENSCHAU_API_URL                         = QStringLiteral("https://www.tagesschau.de/api2/");
static const QString HAFENSCHAU_API_ENDPOINT_NEWS               = QStringLiteral("news/");
static const QString HAFENSCHAU_API_ENDPOINT_HOMEPAGE           = QStringLiteral("homepage/");
static const QString HAFENSCHAU_API_ENDPOINT_INDEX_FEED_COUNT   = QStringLiteral("https://www.tagesschau.de/api2/indexfeedcount");

#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QQueue>

#include "src/news/news.h"
#include "src/news/newsmodel.h"

class ApiInterface : public QObject
{
    Q_OBJECT

public:
    explicit ApiInterface(QObject *parent = nullptr);

    void enableDeveloperMode(bool enable = true);

    QList<int> activeRegions() const;
    NewsModel *newsModel(quint8 newsType = NewsModel::Homepage);

signals:
    void internalLinkAvailable(News *news);
    void newsAvailable(const QList<News *> &news);
    void regionalNewsAvailable(const QList<News *> &news);

public slots:
    void getInteralLink(const QString &link);
    void refresh(quint8 newsType, bool complete = false);
    void setActiveRegions(const QList<int> &regions);

private slots:
    void onInternalLinkRequestFinished();
    void onNewsRequestFinished();
    void onNewStoriesCountRequestFinished();

private:
    QString activeRegionsAsString() const;
    QByteArray getReplyData(QNetworkReply *reply);
    QNetworkRequest getRequest(const QString &endpoint = QString());
    QByteArray gunzip(const QByteArray &data);

    // API helper
    void getNews(quint8 newsType);
    void getNewStoriesCount(NewsModel *model);

    // parsing
    QJsonDocument parseJson(const QByteArray &data);
    News *parseNews(const QJsonObject &obj);
    ContentItemAudio *parseContentItemAudio(const QJsonObject &obj);
    ContentItemBox *parseContentItemBox(const QJsonObject &obj);
    ContentItemGallery *parseContentItemGallery(const QJsonArray &arr);
    ContentItemRelated *parseContentItemRelated(const QJsonArray &arr);
    ContentItemSocial *parseContentItemSocial(const QJsonObject &obj);
    ContentItemVideo *parseContentItemVideo(const QJsonObject &obj);
    bool newNewsAvailable(const QJsonObject &obj);


    QList<int> m_activeRegions;
    bool m_developerMode{false};
    QNetworkAccessManager *m_manager;
    QHash<quint8, NewsModel *> m_newsModels;
};

#endif // APIINTERFACE_H
